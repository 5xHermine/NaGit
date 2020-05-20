class Repository < ApplicationRecord
  blacklists = ["edit", "login", "logout", "password", "new", "cancel", "register", "confirmation", "repositories", "issues", "rails"]
  extend FriendlyId
  validates :title, presence: true, uniqueness: { scope: :user,
                                                  message: ": This title already exitsts!" }
  validates :title, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows alphabets, numbers and underscore." },
                    exclusion: { in: blacklists, message: ": Please change another repository title."}
  belongs_to :user
  has_many :issues, dependent: :destroy

  friendly_id :title, use: :slugged
  before_save :convert_slug_to_same_title

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  private
  def convert_slug_to_same_title
    self.slug = title if slug != title
  end

  private

  def convert_slug_to_same_title
    self.slug = title 
  end

end
