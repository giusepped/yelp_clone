require 'rails_helper'

feature 'endorsing reviews' do
  before do
    user = create(:user)
    user2 = create(:user2)
    restaurant = user.restaurants.create(name: 'The Ivy')
    restaurant.build_review({thoughts: 'great', rating: 5}, user).save
    # restaurant.build_review({thoughts: 'so so', rating: 3}, user2).save
  end

  scenario 'a user can endorse a review, which updates the review endorsement count' do
    visit '/restaurants'
    click_link 'Endorse Review'
    expect(page).to have_content('1 endorsement')
  end
end