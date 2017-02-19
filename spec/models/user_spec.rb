require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with a not-valid password" do
    let(:user){ User.create username:"Pekka", password:"Se1", password_confirmation:"Se1" }

    it "has a password with length of 4 or more" do
      expect(user).not_to be_valid
    end

    it "has at least one capital letter in password" do
      user.password = "secure1"
      user.password_confirmation = "secure1"

      expect(user).not_to be_valid
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }
    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      style = FactoryGirl.create(:style)
      create_beer_with_rating(user, 10, style)
      best = create_beer_with_rating(user, 25, style)
      create_beer_with_rating(user, 7, style)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }
    it "has method for determining the favorite_style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with best average rating if several rated" do
      style = FactoryGirl.create(:style)
      style2 = FactoryGirl.create(:style2)
      create_beer_with_rating(user, 7, style)
      create_beer_with_rating(user, 5, style)
      create_beer_with_rating(user, 7, style2)

      expect(user.favorite_style).to eq(style2)
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }
    it "has method for determining the favorite_brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

   it "is the only brewery with rated beers if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_brewery.name).to eq(beer.brewery.name)
    end

    it "is the brewery with best average rating if several rated" do
      p1 = FactoryGirl.create(:brewery, name:"Panimo1")
      p2 = FactoryGirl.create(:brewery, name:"Panimo2")
      style = FactoryGirl.create(:style)
      p1.beers << create_beer_with_rating(user, 7, style)
      p1.beers << create_beer_with_rating(user, 5, style)
      p2.beers << create_beer_with_rating(user, 7, style)
      expect(user.favorite_brewery.name).to eq("Panimo2")
    end
  end

  def create_beer_with_rating(user, score, style)
    beer = FactoryGirl.create(:beer, style: style)
    FactoryGirl.create(:rating, score: score, beer: beer, user: user)
    beer
  end

  def create_beers_with_ratings(user, *scores)
    scores.each do |score|
      create_beer_with_rating(user, score)
    end
  end
end
