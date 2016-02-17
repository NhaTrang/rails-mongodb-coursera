module Api
  class RacesController < ApiController
    def index
      if !request.accept || request.accept == "*/*"
        if params.nil?
          render plain: "/api/races"
        else
          render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
        end
      else
        # implementation
      end
    end
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      else
        # implementation
      end
    end
    
    def create
      if !request.accept || request.accept == "*/*"
        if params[:race].present?
          render plain: params[:race][:name], status: :ok
        else  
          render plain: :nothing, status: :ok
        end
      else
        race = Race.new(race_params)
        if race.save
          render plain: race.name, status: :created
        else
          render plain: :nothing, status: :error
        end
      end
    end
    
    private 
      def race_params
        params.require(:race).permit(:name, :date)
      end
  end
end