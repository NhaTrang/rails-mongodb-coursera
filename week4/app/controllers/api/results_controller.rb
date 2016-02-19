module Api
  class ResultsController < ApiController
    
    def index
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      else
        @race = Race.find(params[:race_id])
        @entrants = @race.entrants
        fresh_when(last_modified: @race.entrants.max(:updated_at))
      end
    end
    
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else
        @result = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
        render @result
      end
    end
    
    def update
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      else
        @result = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
        result = params[:result]
        if result
          if result[:swim]
            @result.swim = @result.race.race.swim
            @result.swim_secs = result[:swim].to_f
          end
          if result[:t1]
            @result.t1 = @result.race.race.t1
            @result.t1_secs = result[:t1].to_f
          end
          if result[:bike] 
            @result.bike = @result.race.race.bike
            @result.bike_secs = result[:bike].to_f
          end
          if result[:t2] 
            @result.t2 = @result.race.race.t2
            @result.t2_secs = result[:t2].to_f
          end
          if result[:run] 
            @result.run = @result.race.race.run
            @result.run_secs = result[:run].to_f
          end
        end
        @result.save
      end
    end
    
    private 
    def set_params
      params.require(:entrant).permit(:result)
    end
  end
end