class LegResult
  attr_accessor :secs
  include Mongoid::Document
  field :secs, as: :secs, type: Float
  #field :my_ave, type: Float

  embedded_in :entrant
  embeds_one :event, as: :parent
  validates :event, presence: true
  
  after_initialize :calc_ave
  
  def secs
    read_attribute(:secs)
  end
  
  def secs=(value)
    write_attribute(:secs, value)
    calc_ave
  end
  
  def calc_ave
    12.1
  end
end
