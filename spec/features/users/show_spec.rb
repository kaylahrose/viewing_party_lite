require 'rails_helper'

RSpec.describe 'User Dashboard' do
  before :each do
    stub_request(:get, "https://api.themoviedb.org/3/movie/497?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/green_mile/details_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/godfather/details_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/497/credits?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/green_mile/credits_response.json'), headers: {})

    stub_request(:get, "https://api.themoviedb.org/3/movie/497/reviews?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/green_mile/reviews_response.json'), headers: {})
  end

  let!(:charlie) { User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com', password: 'password123', password_confirmation: 'password123') }
  let!(:nicole) { User.create!(name: 'Nicole', email: 'nicoley_oley@yahoo.com', password: 'sosecure123', password_confirmation: 'sosecure123') }

  let!(:party1) do
    ViewingParty.create!(duration: 189, event_date: Date.new(2023, 4, 12), start_time: Time.now - 4.hours,
                         host_id: charlie.id, movie_id: 497)
  end
  let!(:party2) do
    ViewingParty.create!(duration: 104, event_date: Date.new(2023, 3, 21), start_time: Time.now + 4.hours,
                         host_id: nicole.id, movie_id: 238)
  end
  let!(:party3) { ViewingParty.create!(duration: 82, event_date: Date.new(2023, 5, 9), start_time: Time.now + 2.hours) }

  describe 'when I visit the user dashboard' do
    it "will display the user's name" do
      visit user_path(charlie)

      expect(page).to have_content("#{charlie.name}'s Dashboard")
      expect(page).to_not have_content(nicole.name)
    end

    it 'has a button to discover movies' do
      visit user_path(charlie)

      expect(page).to have_button 'Discover Movies'
    end

    it 'has a section that lists viewing parties' do
      UserViewingParty.create!(user_id: charlie.id, viewing_party_id: party1.id)
      UserViewingParty.create!(user_id: charlie.id, viewing_party_id: party2.id)
      UserViewingParty.create!(user_id: nicole.id, viewing_party_id: party3.id)

      visit user_path(charlie)

      within '#viewing_parties' do
        expect(page).to have_content(party1.event_date.strftime('%B %-d, %Y'))
        expect(page).to have_content(party1.start_time.strftime('%I:%M %P'))
        expect(page).to have_content(party2.event_date.strftime('%B %-d, %Y'))
        expect(page).to have_content(party2.start_time.strftime('%I:%M %P'))
        expect(page).to_not have_content(party3.event_date.strftime('%B %-d, %Y'))
      end
    end

    it 'has button to discover movies (movies index)' do
      visit user_path(charlie)
      click_button 'Discover Movies'

      expect(current_path).to eq(discover_user_path(charlie))
    end

    it 'displays the viewing parties for a user' do
      UserViewingParty.create!(user_id: charlie.id, viewing_party_id: party1.id)
      UserViewingParty.create!(user_id: charlie.id, viewing_party_id: party2.id)
      UserViewingParty.create!(user_id: nicole.id, viewing_party_id: party3.id)
      UserViewingParty.create!(user_id: nicole.id, viewing_party_id: party1.id)

      visit user_path(charlie)
      within("#party-#{party1.id}") do
        expect(page).to have_content('The Green Mile')
        expect(page).to have_content(party1.event_date.strftime('%B %-d, %Y'))
        expect(page).to have_content(party1.start_time.strftime('%I:%M %P'))
        expect(page).to have_content('Hosting: Charlie')
        expect(page).to have_content("Attendees: Charlie Nicole")
      end

      within("#party-#{party2.id}") do
        expect(page).to have_content('The Godfather')
        expect(page).to have_content(party2.event_date.strftime('%B %-d, %Y'))
        expect(page).to have_content(party2.start_time.strftime('%I:%M %P'))
        expect(page).to have_content('Hosting: ')
      end
      click_link 'The Green Mile'
      expect(current_path).to eq("/users/#{charlie.id}/movies/497")
    end
  end
end
