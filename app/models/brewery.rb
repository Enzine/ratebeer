class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { less_than_or_equal_to: ->(_) { Time.now.year} }

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  def self.top(n)
    averages = {}
    Brewery.all.each do |brewery|
      averages[brewery] = brewery.average_rating
    end
    Hash[averages.sort_by{|k, v| v}.reverse].take n
  end

end
