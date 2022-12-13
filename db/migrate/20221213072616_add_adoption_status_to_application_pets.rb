class AddAdoptionStatusToApplicationPets < ActiveRecord::Migration[5.2]
  def change
    add_column :application_pets, :adoption_status, :string, default: "Pending"
  end
end
