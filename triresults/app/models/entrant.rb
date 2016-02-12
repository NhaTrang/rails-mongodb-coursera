class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'results'
  
  embeds_many :results, class_name: 'LegResult', order: [:"event.o".asc],
                        after_add: :update_total, after_remove: :update_total
  
  field :bib, as: :bib, type: Integer
  field :secs, as: :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, as: :gender, type: Placing
  field :group, as: :group, type: Placing
  
  def update_total(result)
    self.secs = results.inject(0){|sum,e| sum += e.secs }
  end
end
