class Event
  #conversion
  METERS_IN_MILE     = 0.000621371
  KILOMETERS_IN_MILE = 0.621371
  YARDS_IN_MILE      = 0.000568182
  YARDS_IN_METER     = 0.9144
  MILE_TO_METER     = 1609.34
  
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String
  
  embedded_in :parent, polymorphic: true, touch: true
  
  validates_presence_of :order, :name
  
  def meters
    nil if distance.nil?
    case units
    when nil then nil
    when 'miles' then distance * MILE_TO_METER
    when 'meters' then distance
    when 'kilometers' then distance * 1000
    when 'yards' then distance * YARDS_IN_METER
    end
  end
  
  def miles
    nil if distance.nil?
    case units
    when nil then nil
    when 'miles' then distance
    when 'meters' then distance * METERS_IN_MILE
    when 'kilometers' then distance * KILOMETERS_IN_MILE
    when 'yards' then distance * YARDS_IN_MILE
    end
  end
end
