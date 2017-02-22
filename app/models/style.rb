class Style < ActiveRecord::Base
  has_many :beers, dependent: :destroy

  validates :name, presence: true

  def self.top(n)
    averages = {}
    amount_of_beers = 0
    sum_of_averages = 0
    Style.all.each do |style|
      style.beers.each do |beer|
        amount_of_beers += 1
        sum_of_averages += beer.average_rating
      end
      if sum_of_averages == 0 or amount_of_beers == 0
        averages[style] = 0
      else
        averages[style] = (sum_of_averages / amount_of_beers.to_f).round(2)
      end
    end
    Hash[averages.sort_by{|k, v| v}.reverse].take n
  end
end
