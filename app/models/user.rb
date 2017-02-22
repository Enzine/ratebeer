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

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    sum = Hash.new(0)
    count = Hash.new(0)
    ratings.each do |r|
      sum[r.beer.style] += r.score
      count[r.beer.style] += 1
    end
    sum.max_by { |style, s| (s / count[style].to_f).round(2) }.first
  end

  def favorite_brewery
    return nil if ratings.empty?
    sum = Hash.new(0)
    count = Hash.new(0)
    ratings.each do |r|
      sum[r.beer.brewery] += r.score
      count[r.beer.brewery] += 1
    end
    sum.max_by { |brewery, s| (s / count[brewery].to_f).round(2) }.first
  end

  def self.top(n)
    averages = {}
    User.all.each do |user|
      averages[user] = user.ratings
    end
    Hash[averages.sort_by{|k, v| v.count}.reverse].take n
  end
end
