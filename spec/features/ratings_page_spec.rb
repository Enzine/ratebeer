require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is destroyed when deleted" do
    FactoryGirl.create(:rating, score: 5, beer: beer1, user: user)
    visit user_path(user)
    click_link "delete"
    expect(user.ratings.count).to eq(0)
    expect(Rating.all.count).to eq(0)
  end

  describe "Ratings page" do
    it "should not have any ratings before been created" do
      visit ratings_path
      expect(page).to have_content 'List of ratings'
      expect(page).to have_content 'Number of ratings: 0'
    end

    describe "when ratings exist" do
      before :each do
        FactoryGirl.create(:rating, score: 5, beer: beer1, user: user)
        FactoryGirl.create(:rating, score: 7, beer: beer2, user: user)
        @ratings = Rating.all
        visit ratings_path
      end

      it "lists all ratings and their total number" do
        expect(page).to have_content "Number of ratings: #{@ratings.count}"
        @ratings.each do |rating|
          expect(page).to have_content rating.beer.name
          expect(page).to have_content rating.score
          expect(page).to have_content rating.user.username
        end
      end

    end
  end
end
