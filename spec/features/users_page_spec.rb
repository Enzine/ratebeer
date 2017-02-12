require 'rails_helper'

include Helpers

describe "User" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user){FactoryGirl.create(:user) }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  describe "user page" do
    before :each do
      visit user_path(user)
    end

    it "shows user's favorite_style" do
      expect(page).to have_content "#{user.favorite_style}"
    end

    it "shows user's favorite_brewery" do
      expect(page).to have_content "#{user.favorite_brewery}"
    end
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'password mismatch'
    end

    it "can see a list of his ratings on his user page" do
      FactoryGirl.create(:rating, score: 5, beer: beer1, user: user)
      FactoryGirl.create(:rating, score: 7, beer: beer2, user: user)
      visit user_path(user)
      expect(page).to have_content "ratings"
      @ratings = Rating.all
      @ratings.each do |rating|
        if rating.user == user
          expect(page).to have_content rating.beer.name
          expect(page).to have_content rating.score
        end
      end
    end

    it "cant see others ratings" do
      user2 = FactoryGirl.create(:user, username:"Keijo")
      rating = FactoryGirl.create(:rating, score: 10, beer: beer2, user: user2)
      visit user_path(user)
      expect(page).not_to have_content rating.score
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end
