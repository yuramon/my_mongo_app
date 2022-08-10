class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :email, type: String
  field :address, type: String

  embeds_one :account

  has_many :sender_transactions, class_name: 'Transaction', foreign_key: 'sender_id'
  has_many :recipient_transactions, class_name: 'Transaction', foreign_key: 'recipient_id'

  after_create :create_account

  private
  def create_account
    Account.create!(user: self)
  end
end