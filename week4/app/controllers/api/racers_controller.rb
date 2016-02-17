module Api
  class RacersController < ApiController
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers"
      else
        # implementation
      end
    end
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/racers/#{params[:id]}"
      else
        # implementation
      end
    end
  end
end