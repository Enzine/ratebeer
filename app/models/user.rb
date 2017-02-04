class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..30 }

  validates :password, format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/}, length: { minimum: 4 }

  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  has_many :memberships, dependent: :destroy
  has_many :ratings, dependent: :destroy

  def to_s
    "#{username}"
  end

end
