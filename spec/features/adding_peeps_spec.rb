require_relative 'web_helpers'

feature 'Adding peeps' do
  # as a social media user
  # so i can let people know what im doing
  # i want to post a message (peep) to chitter.
  scenario 'A user can add a peep' do
    sign_up
    click_button('Add peep')
    fill_in('text', :with => 'space is black')
    click_button('Submit')

    expect(page).to have_content('space is black')
  end
end
