require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create(name: 'KFC') }

  scenario 'allows users to leave a review using a form' do
    user = build(:user)
    sign_up(user)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'allows users to delete a review they have created' do
    user = build(:user)
    sign_up(user)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Delete review'

    expect(current_path).to eq '/restaurants'
    expect(page).not_to have_content('so so')
  end

  scenario 'does not allow users to delete a review that is not their own' do
    user = build(:user)
    sign_up(user)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Sign out'
    user2 = build(:user2)
    sign_up(user2)
    expect(page).not_to have_link('Delete review')
  end

  scenario 'displays an average rating for all reviews' do
    user = build(:user)
    sign_up(user)
    leave_review('So so', '3')
    click_link 'Sign out'
    user2 = build(:user2)
    sign_up(user2)
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end

  scenario 'should display N/A if there are no ratings' do
    visit '/restaurants'
    expect(page).to have_content('Average rating: N/A')
  end

  scenario 'displays an average rating for all reviews' do
    user = build(:user)
    sign_up(user)
    leave_review('So so', '3')
    expect(page).to have_content('Average rating: ★★★☆☆')
  end

  scenario 'displays an average rating for all reviews' do
    user = build(:user)
    sign_up(user)
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★★')
  end

  scenario 'displays an average rating for all reviews' do
    user = build(:user)
    sign_up(user)
    leave_review('So so', '3')
    click_link 'Sign out'
    user2 = build(:user2)
    sign_up(user2)
    leave_review('Good', '4')
    expect(page).to have_content('Average rating: ★★★★☆')
  end

end