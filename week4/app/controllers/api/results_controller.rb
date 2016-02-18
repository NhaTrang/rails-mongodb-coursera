module Api
  class ResultsController < ApiController
    before_action :set_objects, only: :show
    
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
    
    private
    def set_objects
      @race = Race.find(params[:race_id])
      @results = Race.find(params[:id])
    end
  end
end