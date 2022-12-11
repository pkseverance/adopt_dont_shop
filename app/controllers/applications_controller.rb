class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @applicationpets = @application.pets

    if params[:search]
      @search_pets = Pet.search(params[:search])
    else
      @search_pets = []
    end
  end

  def new
    @application = Application.new
  end

  def create
    new_app = Application.new(application_params)
    if new_app.save
      redirect_to "/applications/#{new_app.id}"
    else
      flash[:notice] = "Application not created: Required information missing."
      @application = Application.new(application_params)
      @application.save
      render :new
    end
  end

  private

  def application_params
    params
      .require(:application)
      .permit(:name, :street, :city, :state, :zip_code, :description, :status)
      .with_defaults(status: 'In Progress')
  end
end