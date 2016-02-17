module Api
  class ResultsController < ApiController
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      else
        # implementation
      end
    end
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else
        # implementation
      end
    end
  end
end