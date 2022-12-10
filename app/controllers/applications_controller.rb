class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @applicationpets = @application.pets
  end

  def new
  end

  def create
    new_app = Application.create!(application_params)
    redirect_to "/applications/#{new_app.id}"
  end

  private

  def application_params
    params[:status] = 'In Progress'
    params.permit(:name, :street, :city, :state, :zip_code, :description, :status)
  end
end