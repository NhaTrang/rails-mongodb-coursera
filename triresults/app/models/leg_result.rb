class LegResult
  include Mongoid::Document
  field :secs, as: :secs, type: Float
  
  after_initialize do |doc|
  end
  
  def secs=(value)
    secs = value
  end
  
  def calc_ave
  end
end
