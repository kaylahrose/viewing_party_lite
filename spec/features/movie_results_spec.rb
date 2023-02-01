require 'rails_helper'

RSpec.describe 'Movie Results Page' do 

  let!(:charlie) { User.create!(name: "Charlie", email: "charlie_boy@gmail.com") }

  describe 'when the user visits the discover movies page' do 
    xit 'has a button to direct the user to the movie results page' do 

    end
  end 

  describe 'when the user visits the movie results page' do 
    it 'lists a maximum of 20 movie results' do 
      visit user_movies_path(charlie)

      expect(page.status_code).to eq 200 
      # expect(page.results).to be <= 20
    end

    xit 'has a title for each movie as a link to the movie details page' do 

    end

    xit 'displays the vote average for each movie' do 

    end
  end
end