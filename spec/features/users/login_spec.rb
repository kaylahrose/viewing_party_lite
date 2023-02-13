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
end