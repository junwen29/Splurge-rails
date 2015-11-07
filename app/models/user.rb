class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include User::Json
  include User::Authentication

  validate :username_valid, if: :username_changed?
  validates_uniqueness_of :username, allow_blank: true, allow_nil: true, case_sensitive: false,
                          message: "%{value} is already taken", if: :username_changed?

  has_many :friendships
  has_many :passive_friendships, :class_name => "Friendship", :foreign_key => "friend_id"

  has_many :active_friends, -> { where(friendships: { approved: true}) }, :through => :friendships, :source => :friend
  has_many :passive_friends, -> { where(friendships: { approved: true}) }, :through => :passive_friendships, :source => :user
  has_many :pending_friends, -> { where(friendships: { approved: false}) }, :through => :friendships, :source => :friend
  has_many :requested_friendships, -> { where(friendships: { approved: false}) }, :through => :passive_friendships, :source => :user

  #expenses
  has_many :debts, :class_name => 'Expense', :foreign_key => 'borrower_id'
  has_many :lends, :class_name => 'Expense', :foreign_key => 'spender_id'

  has_many :unpaid_debts, -> { where(expenses: { isSettled: false}) }, :class_name => 'Expense', :foreign_key => 'borrower_id'
  has_many :unpaid_lends, -> { where(expenses: { isSettled: false}) }, :class_name => 'Expense', :foreign_key => 'spender_id'

  #trips
  has_many :trips

  #device
  has_many :devices, :dependent => :destroy

  #notification
  has_many :notifications, dependent: :destroy

  def username_valid
    return if username.nil?
    return errors.add(:username, "can't be blank") if username.blank?

    # quick fix for username space error
    self.username = self.username.strip

    valid_characters = "[a-zA-Z_\-]"
    all_numbers = (username =~ Regexp.new('^(?=.*[' + valid_characters + '])')).nil?
    return errors.add(:username, "can't be all numbers") if all_numbers
    invalid_characters = (username =~ Regexp.new('^[' + valid_characters + '0-9]+$')).nil?
    return errors.add(:username, 'can only contain letters, numbers, and underscore') if invalid_characters
  end

  def friends
    active_friends | passive_friends
  end

end
