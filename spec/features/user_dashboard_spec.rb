require 'rails_helper'

RSpec.describe 'User Dashboard' do 

  let!(:charlie) { User.create!(name: "Charlie", email: "charlie_boy@gmail.com") }
  let!(:nicole) { User.create!(name: "Nicole", email: "nicoley_oley@yahoo.com") }

  let!(:party1) { ViewingParty.create!(duration: 82, event_date: Date.new(2023, 4, 12), start_time: Time.now - 4.hours)}
  let!(:party2) { ViewingParty.create!(duration: 104, event_date: Date.new(2023, 3, 21), start_time: Time.now + 4.hours)}
  let!(:party3) { ViewingParty.create!(duration: 82, event_date: Date.new(2023, 5, 9), start_time: Time.now + 2.hours)}

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
      
      within "#viewing_parties" do 
        expect(page).to have_content(party1.event_date.strftime("%B %-d, %Y"))
        expect(page).to have_content(party1.start_time.strftime("%I:%M %P"))
        expect(page).to have_content(party2.event_date.strftime("%B %-d, %Y"))
        expect(page).to have_content(party2.start_time.strftime("%I:%M %P"))
        expect(page).to_not have_content(party3.event_date.strftime("%B %-d, %Y"))
      end
    end

    it 'has button to discover movies (movies index)' do
      visit user_path(charlie)
      click_button 'Discover Movies'

      expect(current_path).to eq(user_movies_path(charlie))
    end
  end
end