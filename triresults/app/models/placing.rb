class Placing
  attr_accessor :name, :place
 
  #def initialize(params)
  #  @name = params[:name]
  #  @place = params[:place]
  #end
  def initialize(name, place)
    @name = name
    @place = place
  end
  
  def mongoize
    {name: @name, place: @place}
  end
  
  def self.mongoize(object)
    simplify(object)
  end
  
  def self.demongoize(object)
    case object
    when nil then nil
    when Hash then Placing.new(object[:name], object[:place])
    end
  end
  
  def self.evolve(object)
    simplify(object)
  end
  
  private
  def self.simplify(object)
    case object
    when nil then nil
    when Hash then {name: object[:name], place: object[:place]}
    when Placing then object.mongoize
    end
  end
end