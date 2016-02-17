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
    
    # GET /api/races/:id
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      else
        @race = Race.find_by(_id: params[:id])
        render json: @race
      end
    end
    
    # PUT,PATCH /api/races/:id
    def update
      Rails.logger.debug("method=#{request.method}")
      @race = Race.find(params[:id])
      @race.update(race_params)
      render json: @race, status: :ok
    end
    
    def create
      if !request.accept || request.accept == "*/*"
        if params[:race].present?
          render plain: params[:race][:name], status: :ok
        else  
          render plain: :nothing, status: :ok
        end
      else
        @race = Race.new(race_params)
        if @race.save
          render plain: @race.name, status: :created
        else
          render plain: :nothing, status: :error
        end
      end
    end
    
    # DELETE /api/races/:id
    def destroy
      @race = Race.find(params[:id])
      @race.destroy
      render nothing: true, status: :no_content
    end
    
    private 
      def race_params
        params.require(:race).permit(:name, :date, :race_id)
      end
  end
end