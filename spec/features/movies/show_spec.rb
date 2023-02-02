require 'rails_helper'

RSpec.describe 'Movie details page' do
  before :each do
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/top_rated_movies_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/discover/movie?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/discover_movies_response.json'), headers: {})
  end

  let!(:charlie) { User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com') }

  describe 'When I visit the movie details page' do
    it 'has button to create viewing party' do
      visit "/users/#{charlie.id}/movies/315162"

      click_button 'Create a Viewing Party'

      expect(current_path).to eq "/users/#{charlie.id}/movies/315162/viewing-party/new"
    end

    it 'has button to return to discover page' do
      visit "/users/#{charlie.id}/movies/315162"

      click_button 'Discover Page'

      expect(current_path).to eq discover_user_path(charlie)
    end
  end
end
