class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  field :amount, type: Float
  field :sender_id, type: BSON::ObjectId
  field :recipient_id, type: BSON::ObjectId

  belongs_to :sender, class_name: 'User', inverse_of: :sender
  belongs_to :recipient, class_name: 'User', inverse_of: :recipient

  scope :user_transactions, ->(user) { where(sender_id: user.id).or(where(recipient_id: user.id)) }

  before_save :update_balances
  validate :sender_not_equal_to_recipient

  private

  def update_balances
    User.with_session do |user|
      begin
        user.start_transaction
        sender.update!(account: { balance: sender.account.balance - amount })
        recipient.update!(account: { balance: recipient.account.balance + amount })
        user.commit_transaction
      end

    end
  end

  def sender_not_equal_to_recipient
    if sender.id == recipient.id
      errors.add(:recipient, "can't be equal to sender ")
    end
  end
end
