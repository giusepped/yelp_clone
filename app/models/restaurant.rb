class Restaurant < ActiveRecord::Base

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/default.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  has_many :reviews, dependent: :destroy

  belongs_to :user

  validates :name, length: {minimum: 3}, uniqueness: true

  def build_review(params, user)
    self.reviews.new(thoughts: params[:thoughts], rating: params[:rating], user_id: user.id)
  end

  def average_rating
    return 'N/A' if self.reviews.none?
    self.reviews.average(:rating).round
  end

end
