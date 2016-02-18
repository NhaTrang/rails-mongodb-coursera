module Api
  class RacesController < ApiController
    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
    end
    
    def index
      if !request.accept || request.accept == "*/*"
        if params.nil?
          render plain: "/api/races"
        else
          render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
        end
      else
        render plain: "#{request.accept}]"
      end
    end
    
    # GET /api/races/:id
    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      else
        if request.accept == 'application/json'
          begin
            @race = Race.find_by(_id: params[:id])
            hash = JSON.parse(@race.to_json)
            hash['name'] = hash.delete 'n'
            render json: hash
          rescue Mongoid::Errors::DocumentNotFound
            hash = {'msg' => "woops: cannot find race[#{params[:id]}]"}
            render json: hash, status: :not_found
          end
        elsif request.accept == 'application/xml'
          begin
            @race = Race.find_by(_id: params[:id])
            race = Nokogiri::XML::Builder.new { |xml| 
              xml.race do
                  xml.name @race.name
                  xml.date @race.date
              end }
            render xml: race
          rescue Mongoid::Errors::DocumentNotFound
            error = Nokogiri::XML::Builder.new { |xml| 
              xml.error do
                  xml.msg "woops: cannot find race[#{params[:id]}]"
              end }
            render xml: error.to_xml, status: :not_found
          end
        else 
          render plain: ' Unsupported content-type[text/plain]', status: :unsupported_media_type
        end
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