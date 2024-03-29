class Point
  attr_accessor :longitude, :latitude

  def initialize params
    if params[:lng].present?
      @longitude = params[:lng]
      @latitude = params[:lat]
    else
      @longitude = params[:coordinates][0]
      @latitude = params[:coordinates][1]
    end
  end

  def to_hash
    {type:"Point", coordinates:[@longitude, @latitude]}
  end

  def latitude
    @latitude
  end

  def longitude
    @longitude
  end

end
