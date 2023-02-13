require 'rails_helper'

RSpec.describe 'User Discover Movies Page' do 

  before :each do
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/top_rated_movies_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/discover_movies_response.json'), headers: {})
  end

  let!(:charlie) { User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com', password: 'password123', password_confirmation: 'password123') }

  it 'redirects to movies results page (movies index)' do 
    visit discover_user_path(charlie) 

    click_button "Top Movies"

    expect(current_path).to eq "/users/#{charlie.id}/movies"
  end

  it 'has a text field to enter keyword(s) to search by movie title' do 
    visit discover_user_path(charlie) 

    fill_in "Search Movie Title:", with: "boots"
    click_button "Search"

    expect(current_path).to eq "/users/#{charlie.id}/movies"
  end
end