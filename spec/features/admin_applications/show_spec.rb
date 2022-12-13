require 'rails_helper'
# [ ] done

# 12. Approving a Pet for Adoption

# As a visitor
# When I visit an admin application show page ('/admin/applications/:id')
# For every pet that the application is for, I see a button to approve the application for that specific pet
# When I click that button
# Then I'm taken back to the admin application show page
# And next to the pet that I approved, I do not see a button to approve this pet
# And instead I see an indicator next to the pet that they have been approved
RSpec.describe 'admin application show page' do
  describe 'As am admin' do
    describe 'when I visit an admin application show page "/admin/applications/:id"' do
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
          status: 'Pending'
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
        @patricia.pets << @pet_1
        visit "/admin/applications/#{@nigel.id}"
      end

      it 'for every pet that the application is for, I see a button to approve the application for that specific pet' do
        within('#app_pets') do
          expect(page).to have_content(@pet_1.name)
          expect(page).to have_button("Approve Adoption for #{@pet_1.name}")
          expect(page).to have_content(@pet_2.name)
          expect(page).to have_button("Approve Adoption for #{@pet_2.name}")
        end
      end
      
      describe 'When I click that button' do
        before :each do
          click_button("Approve Adoption for #{@pet_1.name}")
        end

        it "Then I'm taken back to the admin application show page and next to the pet
          that I approved, I do not see a button to approve this pet 
          And instead I see an indicator next to the pet that they have been approved" do
          expect(current_path).to eq("/admin/applications/#{@nigel.id}")

          within('#app_pets') do
            expect(page).to_not have_button("Approve Adoption for #{@pet_1.name}")
            expect(page).to have_content("#{@pet_1.name} Adoption Approved")
          end
        end
      end

      it 'for every pet that the application is for, I see a button to reject the application for that specific pet' do
        within('#app_pets') do
          expect(page).to have_content(@pet_1.name)
          expect(page).to have_button("Reject Adoption for #{@pet_1.name}")
          expect(page).to have_content(@pet_2.name)
          expect(page).to have_button("Reject Adoption for #{@pet_2.name}")
        end
      end
      
      describe 'When I click that button' do
        before :each do
          click_button("Reject Adoption for #{@pet_1.name}")
        end

        it "Then I'm taken back to the admin application show page and next to the pet
          that I rejected, I do not see a button to approve or reject this pet 
          And instead I see an indicator next to the pet that they have been rejected" do
          expect(current_path).to eq("/admin/applications/#{@nigel.id}")

          within('#app_pets') do
            expect(page).to_not have_button("Approve Adoption for #{@pet_1.name}")
            expect(page).to_not have_button("Reject Adoption for #{@pet_1.name}")
            expect(page).to have_content("#{@pet_1.name} Adoption Rejected")
          end
        end
      end
    end

    describe 'When there are two applications in the system for the same pet' do
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
          status: 'Pending'
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
        @patricia.pets << @pet_1
      end

      describe "When I visit /admin/applications/@nigel.id" do
        before(:each) do
          visit "/admin/applications/#{@nigel.id}"
        end

        describe 'And I approve or reject the pet for that application' do
          before(:each) do
            click_button("Approve Adoption for #{@pet_1.name}")
          end

          describe "When I visit the other application's admin show page" do
            before(:each) do
              visit "/admin/applications/#{@patricia.id}"
            end
            
            it 'Then I do not see that the pet has been accepted or rejected for that application' do
              expect(page).to have_button("Approve Adoption for #{@pet_1.name}")
              expect(page).to have_button("Reject Adoption for #{@pet_1.name}")
              expect(page).to_not have_content("#{@pet_1.name} Adoption Approved")
              expect(page).to_not have_content("#{@pet_1.name} Adoption Rejected")
            end
          end
        end
      end
    end
  end
end