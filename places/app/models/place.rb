class Place
  include ActiveModel::Model

  attr_accessor :id, :formatted_address, :location, :address_components

  def initialize params
    @id = params[:_id].to_s
    @formatted_address = params[:formatted_address]
    @location = Point.new(params[:geometry][:location] || params[:geometry][:geolocation])
    unless params[:address_components].nil?
      @address_components = []
      params[:address_components].each do |add|
        @address_components << AddressComponent.new(add)
      end
    end
  end

  def persisted?
    !@id.nil?
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    self.mongo_client['places']
  end

  def self.load_all file
    data = File.read(file)
    data_hash = JSON.parse(data)

    self.collection.insert_many(data_hash)
  end

  def self.find_by_short_name short_name
    collection.find("address_components.short_name" => short_name)
  end

  def self.to_places views
    result = []

    views.each do |view|
      result << Place.new(view)
    end

    result
  end

  def self.find id
    doc = collection.find(:_id => to_bson(id)).first

    doc.nil? ? nil : Place.new(doc)
  end

  def self.all(offset = 0, limit = "unlimited")
    coll = collection.find
                     .skip(offset)

    coll = coll.limit(limit) unless limit == "unlimited"

    result = []
    coll.each do |item|
      result << Place.new(item)
    end
    result
  end

  def destroy
    self.class.collection.find(:_id => to_bson(@id)).delete_one
  end

  def self.get_address_components(sort = {:number => 1}, offset = 0, limit = nil)
    pipeline = []
    pipeline << {:$unwind => "$address_components"}
    pipeline << {:$project => {:_id => 1,
                               :address_components => 1,
                               :formatted_address => 1,
                               "geometry.geolocation" => 1}}
    pipeline << {:$sort => sort}
    pipeline << {:$skip => offset } unless offset == 0
    pipeline << {:$limit => limit} unless limit.nil?

    collection.find.aggregate(pipeline)
  end

  def self.get_country_names
    pipeline = []
    pipeline << {:$unwind => "$address_components"}
    pipeline << {:$project => {:_id => 1,
                               "address_components.long_name" => 1,
                               "address_components.types" => 1}}
    pipeline << {:$match => {"address_components.types" => "country"}}
    pipeline << {:$group => {:_id => "$address_components.long_name"}}

    collection.find.aggregate(pipeline).to_a.map {|h| h[:_id]}
  end

  def self.find_ids_by_country_code country_code
    pipeline = []
    pipeline << {:$project => {:_id => 1,
                               "address_components.short_name" => 1}}
    pipeline << {:$match => {"address_components.short_name" => country_code}}

    collection.find.aggregate(pipeline).map {|doc| doc[:_id].to_s}
  end

  def self.create_indexes
    collection.indexes.create_one({"geometry.geolocation" => Mongo::Index::GEO2DSPHERE})
  end

  def self.remove_indexes
    collection.indexes.drop_one("geometry.geolocation_2dsphere")
  end

  def self.near point, max_meters = 500000
    collection.find("geometry.geolocation" =>
                    {:$near => {:$geometry => point.to_hash,
                                :$minDistance => 0,
                                :$maxDistance => max_meters}})
  end

  def near max_meters = 500000
    docs = self.class.near(@location, max_meters)

    self.class.to_places docs
  end

  def self.to_bson id
    BSON::ObjectId.from_string(id)
  end

  def to_bson id
    BSON::ObjectId.from_string(id)
  end

  def photos(offset = 0, limit = nil)
    result = self.class.mongo_client.database.fs.find("metadata.place" => @id)

    if result.count == 0
      result = self.class.mongo_client.database.fs.find("metadata.place" => to_bson(@id))
    end

    if result
      result = result.skip(offset)
      result = result.limit(limit) if limit

      photos = []
      result.each do |photo|
        photos << Photo.new(photo)
      end
      photos
    end
  end

end
