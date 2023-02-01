require 'rails_helper'

RSpec.describe 'Movie Results Page' do
  before :each do 
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Api-Key'=>'bcd246575bc3c3494a7259d3f55f76c9',
      'User-Agent'=>'Faraday v2.5.2'
      }).
    to_return(status: 200, body: File.read("./spec/fixtures/top_rated_movies_response.json"), headers: {})  

    stub_request(:get, "https://api.themoviedb.org/3/discover/movie").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Api-Key'=>'bcd246575bc3c3494a7259d3f55f76c9',
      'User-Agent'=>'Faraday v2.5.2'
      }).
    to_return(status: 200, body: File.read("./spec/fixtures/discover_movies_response.json"), headers: {})  
  end

  let!(:charlie) { User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com') }

  describe 'movie db api' do
    it 'displays the top rated movies' do 
      visit discover_user_path(charlie)

      click_button "Top Movies"

      expect(current_path).to eq "/users/#{charlie.id}/movies"
      expect(page.status_code).to eq 200
      expect(page).to have_content("The Godfather")
      expect(page).to have_content("The Green Mile")
      expect(page).to_not have_content("M3GAN")
    end

    it 'searches for movie by title' do 
      visit discover_user_path(charlie)

      fill_in "Search Movie Title:", with: "the"
      click_button "Search"

      expect(current_path).to eq "/users/#{charlie.id}/movies"
      expect(page.status_code).to eq 200
      expect(page).to have_content("The Enforcer")
      expect(page).to have_content("Avatar: The Way of Water")
      expect(page).to_not have_content("Devotion")
    end

    it 'lists a maximum of 20 movie results' do
      visit discover_user_path(charlie)

      click_button "Top Movies"

      expect(page.status_code).to eq 200
      expect(page.all("Vote Average").count).to be <= 20 
    end

    it 'has a title for each movie as a link to the movie details page' do
      visit discover_user_path(charlie)

      click_button "Top Movies"

      expect(current_path).to eq "/users/#{charlie.id}/movies"
      click_link("The Godfather")

      expect(current_path).to eq "/users/#{charlie.id}/movies/238"

      visit discover_user_path(charlie)

      fill_in "Search Movie Title:", with: "the"
      click_button "Search"

      expect(current_path).to eq "/users/#{charlie.id}/movies"
      click_link("The Enforcer")

      expect(current_path).to eq "/users/#{charlie.id}/movies/846433"
    end

    it 'displays the vote average for each movie' do
      visit discover_user_path(charlie)

      click_button "Top Movies"

      expect(current_path).to eq "/users/#{charlie.id}/movies"
      expect(page).to have_content("Vote Average: 8.7")
    end

    describe 'sad path' do 
      it 'displays a message if search did not find a result' do 
        visit discover_user_path(charlie)

        fill_in "Search Movie Title:", with: ";osifgn"
        click_button "Search"
  
        expect(current_path).to eq discover_user_path(charlie)
        expect(page).to have_content("No results found. Please try another title.")
      end
    end
  end
end
