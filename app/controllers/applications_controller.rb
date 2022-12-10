class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @applicationpets = @application.pets
  end

  def new
    # @application = Application.new 
    # Possibly use this to save form fills when an error occurs and redirects back to this new page
  end

  def create
    
    new_app = Application.new(application_params)
    if new_app.save
      redirect_to "/applications/#{new_app.id}"
    else
      flash[:notice] = "Application not created: Please fill out all fields."
      redirect_to "/applications/new"
      # render :new
      # Don't understand the difference between render and redirect
    end
  end

  private

  def application_params
    params[:status] = 'In Progress'
    params.permit(:name, :street, :city, :state, :zip_code, :description, :status)
  end
end