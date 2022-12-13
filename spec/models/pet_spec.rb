require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:application_pets) }
    it { should have_many(:applications).through(:application_pets)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @nigel = Application.create!(name: 'Nigel', street: '1234 Turing Pwky', city: 'San Antonio', state: 'TX', zip_code: 54321, description: 'Loving family with financial stability', status: 'Pending')
    @patricia = Application.create!(name: 'Patricia', street: '4567 Dev Street', city: 'Denver', state: 'CO', zip_code: 98765, description: 'Great with pets.', status: 'Pending')
    ApplicationPet.create!(application: @nigel, pet: @pet_1, adoption_status: 'Approved')
    ApplicationPet.create!(application: @nigel, pet: @pet_2, adoption_status: 'Pending')
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '#adoption_status' do
      it 'returns the application_pet adoption_status' do
        expect(@pet_1.adoption_status(@nigel.id)).to eq('Approved')
        expect(@pet_2.adoption_status(@nigel.id)).to eq('Pending')
      end
    end
  end
end
