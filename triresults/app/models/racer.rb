class Racer
  include Mongoid::Document
  
  embeds_one :info, autobuild: true, class_name: 'RacerInfo'
  has_many :races, class_name: 'Entrant', foreign_key: "racer.racer_id",
                  order: :"race.date".desc, dependent: :nullify
  
  before_create do |racer|
    racer.info.id = racer.id
  end
end
