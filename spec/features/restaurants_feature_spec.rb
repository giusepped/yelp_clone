require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      user = build(:user)
      sign_up(user)
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content('KFC')
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'it does not let you submit a name that is too short' do
        user = build(:user)
        sign_up(user)
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'let a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before(:each) do
      user = build(:user)
      visit '/'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'does not let user 2 edit the restaurant' do
      click_link 'Sign out'
      user2 = build(:user2)
      sign_up(user2)
      click_link 'Edit KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
    before(:each) do
      user = build(:user)
      visit '/'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'does not let user 2 delete the restaurant' do
      click_link 'Sign out'
      user2 = build(:user2)
      sign_up(user2)
      click_link 'Delete KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

  scenario 'I can add an image to a restaurant when creating a restaurant' do
    user = build(:user)
    visit '/'
    sign_up(user)
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    attach_file "restaurant[image]", "spec/asset_specs/images/image.png"
    click_button 'Create Restaurant'
    expect(page).to have_selector("img")
  end

  scenario 'I can add an image to a restaurant when creating a restaurant' do
    user = build(:user)
    visit '/'
    sign_up(user)
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    attach_file "restaurant[image]", "spec/asset_specs/images/image.png"
    click_button 'Create Restaurant'
    click_link 'Edit KFC'
    attach_file "restaurant[image]", "spec/asset_specs/images/image.png"
    click_button 'Update Restaurant'
    expect(page).to have_selector("img")
  end


end