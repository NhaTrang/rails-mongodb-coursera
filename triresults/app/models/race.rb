class Race
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :n, as: :name, type: String
  field :date, as: :date, type: Date
  field :loc, as: :location, type: Address
  
  scope :upcoming, -> { where(:date.gte => Date.today) }
  scope :past, -> { where(:date.lt => Date.today) }
  
  embeds_many :events, as: :parent, class_name: 'Event', order: [:order.asc]
  has_many :entrants, class_name: 'Entrant', foreign_key: 'race._id', order: [:secs.asc, :bib.asc], dependent: :delete
end
