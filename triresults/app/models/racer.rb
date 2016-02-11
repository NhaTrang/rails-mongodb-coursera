class Racer
  include Mongoid::Document
  
  embeds_one :info, autobuild: true, class_name: 'RacerInfo'
  
  before_create do |racer|
    racer.info.id = racer.id
  end
end
