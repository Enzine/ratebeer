require 'rails_helper'

include Helpers

describe "Beer" do

  before :each do
    FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create :brewery, name:"Koff"
    FactoryGirl.create :style
  end

  it "is added when given valid credentials" do
    visit new_beer_path

    fill_in('beer[name]', with:'Olut')
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')
    expect{
      click_button('Create Beer')
      }.to change{Beer.count}.by(1)

  end

  it "is not added if wrong credentials given" do
    visit new_beer_path
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')

    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
  end
end
