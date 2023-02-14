require 'rails_helper'

RSpec.describe 'user login page' do

  let!(:charlie) { User.create!(name: 'Charlie', email: 'charlie_boy@gmail.com', password: 'password123', password_confirmation: 'password123') }

  it 'has a link to log in on the landing page' do 
    visit root_path

    click_link "Log In"

    expect(current_path).to eq login_path
  end

  it 'takes the user to their dashboard when they log in with correct email and password' do 
    visit root_path

    click_link "Log In"

    expect(current_path).to eq login_path

    fill_in 'email', with: 'charlie_boy@gmail.com'
    fill_in 'password', with: 'password123'
    click_button "Log In"

    expect(current_path).to eq user_path(charlie)
    expect(page).to have_content("Welcome, #{charlie.name}")
  end

  it 'will not log in with an invalid password' do 
    visit login_path

    fill_in 'email', with: 'charlie_boy@gmail.com'
    fill_in 'password', with: 'password'
    click_button "Log In"

    expect(current_path).to eq login_path
    expect(page).to have_content("Incorrect credentials. Please login again.")
  end

  it 'will not log in with an invalid email' do 
    visit login_path

    fill_in 'email', with: 'charlie@gmail.com'
    fill_in 'password', with: 'password123'
    click_button "Log In"

    expect(current_path).to eq login_path
    expect(page).to have_content("Incorrect credentials. Please login again.")
  end

  describe 'logged out user or visitor' do 
    it 'will show log in and create account options if user not logged in' do 
      visit root_path 

      expect(page).to have_link("Log In")
      expect(page).to have_button("Create a New User")
      expect(page).to_not have_link("Log Out")
    end

    it 'will show link to log out on landing page if user is logged in' do 
      visit login_path 
    
      fill_in 'email', with: 'charlie_boy@gmail.com'
      fill_in 'password', with: 'password123'
      click_button "Log In"
  
      visit root_path 

      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_button("Create a New User")

      click_link "Log Out"

      expect(current_path).to eq root_path
      expect(page).to have_link("Log In")
      expect(page).to have_button("Create a New User")
      expect(page).to_not have_link("Log Out")
    end

    it 'will not let visitor or logged out user go to a user show page' do 
      visit user_path(charlie)

      expect(current_path).to eq root_path
      expect(page).to have_content("Must be logged in or registered to access dashboard")
    end
  end
end