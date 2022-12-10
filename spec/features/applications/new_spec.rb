require 'rails_helper'

RSpec.describe 'Application New Form Page' do
  describe 'As a user' do
    describe 'When I visit "/applications/new"' do
      it 'then I see a new application form' do
        visit '/applications/new'

        expect(page).to have_field('Name')
        expect(page).to have_field('Street Address')
        expect(page).to have_field('City')
        expect(page).to have_field('State')
        expect(page).to have_field('Zip Code')
        expect(page).to have_field("Description of why you'd be a good home for this pet(s)")
        expect(page).to have_button('Submit')
      end

      describe 'When I fill in this form and click submit' do
        before :each do
          visit '/applications/new'
          save_and_open_page
          fill_in('Name', with: 'Joey')
          fill_in('Street Address', with: '678 Ruby Road')
          fill_in('City', with: 'Austin')
          fill_in('State', with: 'TX')
          fill_in('Zip Code', with: 10345)
          fill_in("Description of why you'd be a good home for this pet(s)", with: 'I love pets')
          click_button('Submit')

          @joey = Application.last
        end

        it "Then I am taken to the new application's show page" do
          expect(current_path).to eq("/applications/#{@joey.id}") 
        end

        it 'Then I see my name, address info, and description' do
          expect(page).to have_content(@joey.name)
          expect(page).to have_content(@joey.street)
          expect(page).to have_content(@joey.city)
          expect(page).to have_content(@joey.state)
          expect(page).to have_content(@joey.zip_code)
          expect(page).to have_content(@joey.description)
        end

        it 'Then I see an indicator that this application is "In Progress"' do
          expect(@joey.status).to eq('In Progress')
          expect(page).to have_content('In Progress')
        end
      end
    end
  end
end
