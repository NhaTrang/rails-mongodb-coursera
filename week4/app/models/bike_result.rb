class BikeResult < LegResult
  field :mph, type: Float
  
  def calc_ave
    if event && secs
      self.mph = event.miles * 3600 / secs
    else
      super
    end
  end
end
