class Restaurant < ActiveRecord::Base
  has_many :reviews, dependent: :destroy

  belongs_to :user

  validates :name, length: {minimum: 3}, uniqueness: true

  def build_review(params, user)
    self.reviews.new(thoughts: params[:thoughts], rating: params[:rating], user_id: user.id)
  end

  def average_rating
    return 'N/A' if self.reviews.none?
    self.reviews.average(:rating).to_i
  end

end
