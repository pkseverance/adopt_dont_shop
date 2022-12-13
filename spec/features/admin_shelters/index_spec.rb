# SQL Only Story

# For this story, you should write your queries in raw sql. 
# You can use the ActiveRecord find_by_sql method to execute raw sql queries: 
# https://guides.rubyonrails.org/active_record_querying.html#finding-by-sql

# 10. Admin Shelters Index

# As a visitor
# When I visit the admin shelter index ('/admin/shelters')
# Then I see all Shelters in the system listed in reverse alphabetical order by name
require 'rails_helper'

RSpec.describe 'Admin Shelters Index' do
  describe 'As a user' do
    describe 'When I visit the admin shelter index "/admin/shelters"' do
      before :each do
        @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
        @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

        @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
        @pet_2 = @shelter_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
        @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
        
        @nigel = Application.create!(name: 'Nigel', street: '1234 Turing Pwky', city: 'San Antonio', state: 'TX', zip_code: 54321, description: 'Loving family with financial stability', status: 'In Progress')
        @patricia = Application.create!(name: 'Patricia', street: '4567 Dev Street', city: 'Denver', state: 'CO', zip_code: 98765, description: 'Great with pets.', status: 'Pending')
        
        @nigel.pets << @pet_1
        @nigel.pets << @pet_2
        @nigel.pets << @pet_3

        @patricia.pets << @pet_3
      end

      it 'Then I see all Shelters in the system listed in reverse alphabetical order by name' do
        visit '/admin/shelters'
        
        expect(page).to have_content(@shelter_1.name)
        expect(page).to have_content(@shelter_2.name)
        expect(page).to have_content(@shelter_3.name)
        expect(@shelter_2.name).to appear_before(@shelter_3.name)
        expect(@shelter_3.name).to appear_before(@shelter_1.name)
      end

      describe 'Then I see a section for Shelters with Pending Applications' do
        it 'And in this section I see the name of every shelter that has a pending application' do
          visit '/admin/shelters'

          within('section#pending_apps') do
            expect(page).to have_content('Shelters with Pending Applications')
            expect(page).to have_content(@shelter_3.name)
            expect(page).to_not have_content(@shelter_1.name)
            expect(page).to_not have_content(@shelter_2.name)
          end
        end
      end
    end
  end
end