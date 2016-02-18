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
        @result = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
        Rails.logger.debug("result ===== #{@result._id}")
        render @result
      end
    end
  end
end