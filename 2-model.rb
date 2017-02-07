class User < ActiveRecord::Base
  include Archivable
  include Users::Callbacks

  enum role: {
    guest: 0,
    account_user: 1,
    account_admin: 2,
    root: 3
  }

  belongs_to :account

  with_options dependent: :destroy do |m|
    m.has_many :invitations
    m.has_many :locks
    m.has_many :password_resets
    m.has_many :memberships
    m.has_many :orders
  end

  has_many :teams, through: :memberships
  has_one :latest_lock, class_name: 'Lock'

  validates_presence_of :email
  validates_presence_of :role
  validates_presence_of :username

  validates_format_of :email, with: /@.*\./
  validates_uniqueness_of :email

  before_validation :downcase_email
  before_create :autoset_api_access_token

  scope :by_full_name,             -> { order(:last_name, :first_name) }
  scope :by_username,              -> { order(:username) }
  scope :member_of,                -> (team) { joins(:memberships).where(team_id: team) }
  scope :search,                   -> (query) { Users::Scopes.search(query) }
  scope :subscribed_to_newsletter, -> { where(unsubscribed_at: nil) }

  def balance
    Users::CalculateBalance.perform_now(self)
  end

  def full_name
    unless first_name.blank? || last_name.blank?
      "#{first_name} #{last_name}"
    end
  end

  def last_locked_out_at
    latest_lock.created_at if latest_lock
  end

end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  account_id      :integer          not null
#  username        :string(255)      not null
#  email           :string(255)      not null
#  first_name      :string(255)
#  last_name       :string(255)
#  password_digest :string(255)
#  role            :integer          default("0")
#  unsubscribed_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
