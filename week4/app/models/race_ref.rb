class RaceRef
  include Mongoid::Document
  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  
  embedded_in :entrant
  belongs_to :race, class_name: 'Race', foreign_key: '_id'
end
