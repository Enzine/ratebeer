class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{name}, from #{brewery.name}"
  end

  def self.top(n)
    averages = {}
    Beer.all.each do |beer|
      averages[beer] = beer.average_rating
    end
    Hash[averages.sort_by{|k, v| v}.reverse].take n
  end
end
