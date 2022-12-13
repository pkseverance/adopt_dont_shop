class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  def shelter_name
    shelter.name
  end

  def adoption_status(application_id)
    app_pet = ApplicationPet.find_by(application_id: application_id, pet_id: self.id)
    app_pet.adoption_status
  end

  def self.adoptable
    where(adoptable: true)
  end
end
