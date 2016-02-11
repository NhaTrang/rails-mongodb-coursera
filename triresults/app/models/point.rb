class Point
  attr_accessor :longitude, :latitude
  
  def initialize(lon, lat)
    @longitude = lon
    @latitude = lat
  end
  
  def mongoize
    {type: 'Point', coordinates: [@longitude, @latitude]}
  end
  
  def self.mongoize(object)
    simplify(object)
  end
  
  def self.demongoize(object)
    case object
    when nil then
      nil
    when Hash then
      Point.new(object[:coordinates][0], object[:coordinates][1])
    when Point then
      Point.new(object.longitude, object.latitude)
    end
  end
  
  def self.evolve(object)
    simplify(object)
  end
  
  private
  def self.simplify(object)
    case object
    when nil then
      nil
    when Hash then
      {coordinates: [object[:coordinates][0], object[:coordinates][1]]}
    when Point then
      {coordinates: [object.longitude, object.latitude]}
    end
  end
end