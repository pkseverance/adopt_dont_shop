class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @application_pets = @application.pets
  end

  def update
    @application = Application.find(params[:id])
    application_pet = ApplicationPet.find_by(application_id: params[:id], pet_id: params[:pet_id])
    application_pet.update_attribute(:adoption_status, params[:adoption_status])
    redirect_to "/admin/applications/#{@application.id}"
  end
end