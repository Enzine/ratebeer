class BeerClub < ActiveRecord::Base
  has_many :users, through: :memberships
  has_many :memberships, dependent: :destroy

  def to_s
    "#{name}"
  end

end
