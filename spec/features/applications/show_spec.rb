require 'rails_helper'

# 1. Application Show Page

# As a visitor
# When I visit an applications show page
# Then I can see the following:
# - Name of the Applicant
# - Full Address of the Applicant including street address, city, state, and zip code
# - Description of why the applicant says they'd be a good home for this pet(s)
# - names of all pets that this application is for (all names of pets should be links to their show page)
# - The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"


# 4. Searching for Pets for an Application

# As a visitor
# When I visit an application's show page
# And that application has not been submitted,
# Then I see a section on the page to "Add a Pet to this Application"
# In that section I see an input where I can search for Pets by name
# When I fill in this field with a Pet's name
# And I click submit,
# Then I am taken back to the application show page
# And under the search bar I see any Pet whose name matches my search

RSpec.describe "Applications Show Page" do
  describe "As a visitor" do
    describe "When I visit the applications show page" do
      before :each do
        @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
        @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
        @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
        @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
        @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

        @nigel = Application.create!(
          name: 'Nigel',
          street: '1234 Turing Pwky',
          city: 'San Antonio',
          state: 'TX',
          zip_code: 54321,
          description: 'Loving family with financial stability',
          status: 'In Progress'
        )
        @patricia = Application.create!(
          name: 'Patricia',
          street: '4567 Dev Street',
          city: 'Denver',
          state: 'CO',
          zip_code: 98765,
          description: 'Great with pets.',
          status: 'Pending'
        )
        @nigel.pets << @pet_1
        @nigel.pets << @pet_2
        @pet_1.applications << @patricia
      end
      it 'Then I see the name of the applicant' do
        visit "/applications/#{@nigel.id}"
        
        expect(page).to have_content("Name: #{@nigel.name}")
      end

      it 'Then I see the full address of the applicant including street address, city, state,
      and zip code' do
        visit "/applications/#{@nigel.id}"
        
        expect(page).to have_content(@nigel.street)
        expect(page).to have_content(@nigel.city)
        expect(page).to have_content(@nigel.state)
        expect(page).to have_content(@nigel.zip_code)
      end

      it "Then I see the description of why the applicant says they'd be a good home for this pet(s)" do
        visit "/applications/#{@nigel.id}"

        expect(page).to have_content(@nigel.description)
      end

      it "Then I see the names of all pets that this application is for
      (all names of pets should be links to their showpage)" do
        visit "/applications/#{@nigel.id}"
        
        expect(page).to have_link("#{@pet_1.name}", href: "/pets/#{@pet_1.id}")
        expect(page).to have_link("#{@pet_2.name}", href: "/pets/#{@pet_2.id}")

        click_link("#{@pet_1.name}")

        expect(current_path).to eq("/pets/#{@pet_1.id}")

        visit "/applications/#{@patricia.id}"
        
        
        expect(page).to have_link("#{@pet_1.name}", href: "/pets/#{@pet_1.id}")
      end

      it "Then I see the application's status, either 'In Progress', 'Pending', 'Accepted', or 'Rejected" do
        visit "/applications/#{@nigel.id}"

        expect(page).to have_content(@nigel.status)
      end

      it 'Then I see a section on page to add a pet to this application' do
        visit "/applications/#{@nigel.id}"

        expect(page).to have_content('Add a pet to this application')
        expect(page).to have_field('Search for Pets')
      end

      it 'Under the search bar I see any Pet whose name matches my search' do
        visit "/applications/#{@nigel.id}"

        fill_in('Search for Pets', with: "#{@pet_1.name}")
        click_button('Submit')

        within('section#add_pet') do
          expect(page).to have_content("#{@pet_1.name}")
        end
      end

      it 'Can display other pets' do
        visit "/applications/#{@nigel.id}"

        fill_in('Search for Pets', with: "#{@pet_2.name}")
        click_button('Submit')

        within('section#add_pet') do
          expect(page).to have_content("#{@pet_2.name}")
        end
      end

      it 'Tests for partial matches' do
        visit "/applications/#{@nigel.id}"

        fill_in('Search for Pets', with: "a")
        click_button('Submit')

        within('section#add_pet') do
          expect(page).to have_content("#{@pet_1.name}")
          expect(page).to have_content("#{@pet_2.name}")
          expect(page).to have_content("#{@pet_3.name}")
        end
      end

      it 'Shows nothing if name != any pets' do
        visit "/applications/#{@nigel.id}"

        fill_in('Search for Pets', with: "Dr. Stinkface")
        click_button('Submit')

        within('section#add_pet') do
          expect(page).to_not have_content("#{@pet_1.name}")
          expect(page).to_not have_content("#{@pet_2.name}")
          expect(page).to_not have_content("#{@pet_3.name}")
        end
      end
    end
  end
end