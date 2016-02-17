class RunResult < LegResult
  field :mmile, as: :minute_mile, type: Float
  
  def calc_ave
    if event && secs
      self.minute_mile = (secs / 60) / event.miles
    else
      super
    end
  end
end