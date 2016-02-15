class Address
  attr_accessor :city, :state, :location
  
  def initialize(params = {})
    if params.nil?
      @city = ''
      @state = ''
      @location = ''
    else
      @city = params[:city]
      @state = params[:state]
      @location = Point.demongoize(params[:loc])
    end
  end
  
  def mongoize
    point = @location
    {city: @city, state: @state, loc: point.mongoize}
  end
  
  def self.demongoize(object)
    case object
    when nil then nil
    when Hash then Address.new(object)
    end
  end
  
  def self.evolve(object)
    case object
    when nil then nil
    when Hash then {city: object[:city], state: object[:state],
                          loc: {type: object[:loc][:type],
                          coordinates: [object[:loc][:coordinates][0],object[:loc][:coordinates][1]]}}
    when Address then object.mongoize
    end
  end
end