require 'rails_helper'

describe "Places" do
  before :each do
    allow(BeerweatherApi).to receive(:fetch_weather_in).with("kumpula").and_return(
       {
         temperature: 50,
         feelslike: 100,
         text: "boiling",
         icon: "www.google.fi",
         wind: 1000000
       }
    )
  end
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, those are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Pubi", id: 2 ) ]
    )
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Pubi"
  end

  it "if none returned by the API a nice error message is displayed" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      []
    )
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula or no such city"
  end
end
