require 'rails_helper'

RSpec.describe 'Movie details page' do
  before :each do
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/top_rated_movies_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/497/credits?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/green_mile/credits_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/497?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/green_mile/details_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/497/reviews?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/green_mile/reviews_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/238/reviews?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/godfather/reviews_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/238/credits?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/godfather/credits_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/godfather/details_response.json'), headers: {})
  end 

  let!(:charlie) { User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com', password: 'password123', password_confirmation: 'password123') }

  describe 'When I visit the movie details page' do
    it 'has button to create viewing party' do
      visit "/users/#{charlie.id}/movies/497"

      click_button 'Create a Viewing Party'

      expect(current_path).to eq "/users/#{charlie.id}/movies/497/viewing-party/new"
    end

    it 'has button to return to discover page' do
      visit "/users/#{charlie.id}/movies/497"

      click_button 'Discover Page'

      expect(current_path).to eq discover_user_path(charlie)
    end

    it 'displays movie info' do
      visit "/users/#{charlie.id}/movies/497"

      expect(page).to have_content('The Green Mile')
      expect(page).to have_content('Vote Average: 8.5')
      expect(page).to have_content('Runtime: 3hr 9min')
      expect(page).to have_content('Genre: Fantasy, Drama, Crime')
      within('#summary') do
        expect(page).to have_content('Summary')
        expect(page).to have_content('A supernatural tale set on death row')
      end

      within('#cast') do
        expect(page).to have_content('Cast')
        expect(page).to have_content('Tom Hanks as Paul Edgecomb')
        expect(page).to have_content('David Morse as Brutus "Brutal" Howell')
        expect(page).to have_content('Bonnie Hunt as Jan Edgecomb')
        expect(page).to have_content('Michael Clarke Duncan as John Coffey')
        expect(page).to have_content('James Cromwell as Warden Hal Moores')
        expect(page).to have_content('Michael Jeter as Eduard Delacroix')
        expect(page).to have_content('Graham Greene as Arlen Bitterbuck')
        expect(page).to have_content('Doug Hutchison as Percy Wetmore')
        expect(page).to have_content("Sam Rockwell as 'Wild Bill' Wharton")
        expect(page).to have_content('Barry Pepper as Dean Stanton')
        expect(page.all('as').count).to be <= 10
      end

      within('#reviews') do
        expect(page).to have_content('0 Reviews')
      end

      visit "/users/#{charlie.id}/movies/238"

      within('#reviews') do
        expect(page).to have_content('2 Reviews')
        expect(page).to have_content('Author: futuretv')
        expect(page).to have_content('Author: crastana')
        expect(page).to have_content('Content: The Godfather Review by Al Carlson')
        expect(page).to have_content('Content: The best movie ever...')
      end
    end
  end
end
