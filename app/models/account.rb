class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  field :balance, type: Float, default: 0.0

  embedded_in :user
end
