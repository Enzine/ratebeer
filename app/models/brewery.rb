class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   less_than_or_equal_to: proc { Time.current.year },
                                   only_integer: true }

  def restart
    year = 2016
    puts "changed year to #{year}"
  end

end
