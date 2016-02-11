class Racer
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :first_name, type: String, as: :fn
  field :last_name, type: String, as: :ln
  field :date_of_birth, type: Date, as: :dob
  field :gender, type: String
end
