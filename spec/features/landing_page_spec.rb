require 'rails_helper'

RSpec.describe 'landing page' do
  describe 'when a user visits the root path' do
    it 'has the Viewing Party title' do
      visit root_path

      expect(page).to have_content 'Viewing Party'
    end

    it 'has a button to create a new user' do
      visit root_path

      click_button 'Create a New User'

      expect(current_path).to eq register_path
      expect(page).to have_content 'Register New User'
    end

    it 'has links of all existing users' do
      charlie = User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com', password: 'password123', password_confirmation: 'password123')
      nicole = User.create!(name: 'Nicole', email: 'nicoley_oley@yahoo.com', password: 'sosecure123', password_confirmation: 'sosecure123')
      sara = User.create!(name: 'Sara', email: 'sara1983@gmail.com', password: 'password', password_confirmation: 'password')
      
      visit login_path
    
      fill_in 'email', with: 'charlie_boy@gmail.com'
      fill_in 'password', with: 'password123'
      click_button "Log In"
  
      visit root_path

      within '#users' do
        expect(page).to have_content(charlie.email)
        expect(page).to have_content(nicole.email)
        expect(page).to have_content(sara.email)
      end
    end

    it 'has a link to go to the landing page' do
      visit root_path

      click_link 'Home'

      expect(current_path).to eq root_path
    end
  end
end
