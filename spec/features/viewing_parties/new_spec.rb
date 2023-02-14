require 'rails_helper'

RSpec.describe 'The new viewing party page' do
  before :each do
    stub_request(:get, "https://api.themoviedb.org/3/movie/497?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: File.read('./spec/fixtures/green_mile/details_response.json'), headers: {})
  end

  let!(:charlie) { User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com', password: 'password123', password_confirmation: 'password123') }
  let!(:cindy) { User.create!(name: 'Cindy', email: 'user@gmail.com', password: 'sosecure123', password_confirmation: 'sosecure123') }
  let!(:louis) { User.create!(name: 'Louis', email: 'email_me@gmail.com', password: 'password', password_confirmation: 'password') }

  it 'lists the movie title above the form' do
    visit login_path 
    
    fill_in 'email', with: 'charlie_boy@gmail.com'
    fill_in 'password', with: 'password123'
    click_button "Log In"

    visit "/users/#{charlie.id}/movies/497/viewing-party/new"

    expect(page).to have_content('The Green Mile')
  end

  describe 'happy path' do
    it 'creates a new viewing party with default duration and no other users' do
      visit login_path

      fill_in 'email', with: 'charlie_boy@gmail.com'
      fill_in 'password', with: 'password123'
      click_button "Log In"

      visit "/users/#{charlie.id}/movies/497/viewing-party/new"
      expect(ViewingParty.all).to eq([])
      within('#form') do
        fill_in 'day', with: Date.tomorrow
        fill_in 'time', with: Time.now
        click_button 'Create Party'
      end
      expect(ViewingParty.all.count).to eq(1)
      expect(ViewingParty.all[0].host_id).to eq(charlie.id)
      expect(current_path).to eq(user_path(charlie))
    end

    it 'creates viewing party with custom duration and no other users' do
      visit login_path

      fill_in 'email', with: 'charlie_boy@gmail.com'
      fill_in 'password', with: 'password123'
      click_button "Log In"

      visit "/users/#{charlie.id}/movies/497/viewing-party/new"
      
      within('#form') do
        fill_in 'duration', with: '200'
        fill_in 'day', with: Date.tomorrow
        fill_in 'time', with: Time.now
        click_button 'Create Party'
      end

      expect(current_path).to eq(user_path(charlie))
    end

    it 'creates viewing party with default duration and other users' do
      visit login_path

      fill_in 'email', with: 'charlie_boy@gmail.com'
      fill_in 'password', with: 'password123'
      click_button "Log In"

      visit "/users/#{charlie.id}/movies/497/viewing-party/new"
      
      within('#form') do
        fill_in 'day', with: Date.tomorrow
        fill_in 'time', with: Time.now
        check cindy.name
        click_button 'Create Party'
      end

      expect(current_path).to eq(user_path(charlie))
      expect(cindy.user_viewing_parties.count).to eq(1)
      expect(UserViewingParty.all.count).to eq 2
    end

    it 'shows up on other users dashboards (show pages)' do
      visit login_path

      fill_in 'email', with: 'user@gmail.com'
      fill_in 'password', with: 'sosecure123'
      click_button "Log In"

      visit "/users/#{charlie.id}/movies/497/viewing-party/new"
      
      within('#form') do
        fill_in 'day', with: Date.tomorrow
        fill_in 'time', with: Time.now
        check cindy.name
        click_button 'Create Party'
      end

      visit user_path(cindy)

      within '#viewing_parties' do
        expect(page).to have_content(cindy.viewing_parties[0].event_date.strftime('%B %-d, %Y'))
      end
    end
  end

  describe 'sad path' do
    it 'does not create viewing party with duration less than movie runtime' do
      visit login_path 
    
      fill_in 'email', with: 'charlie_boy@gmail.com'
      fill_in 'password', with: 'password123'
      click_button "Log In"

      visit "/users/#{charlie.id}/movies/497/viewing-party/new"
      
      expect(ViewingParty.all).to eq([])
      
      within('#form') do
        fill_in 'duration', with: 0
        fill_in 'day', with: Date.tomorrow
        fill_in 'time', with: Time.now
        click_button 'Create Party'
      end
      
      expect(current_path).to eq("/users/#{charlie.id}/movies/497/viewing-party/new")
      expect(page).to have_content('Party time must be longer than the movie runtime.')
      expect(ViewingParty.all).to eq([])
    end
  end
end
