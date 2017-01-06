class Brewery < ActiveRecord::Base
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def restart
    year = 2016
    puts "changed year to #{year}"
  end

end
