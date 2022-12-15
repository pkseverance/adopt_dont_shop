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

  def update
    @application = Application.find(params[:id])
    # binding.pry
    if params[:commit] == "Submit Application"
      flash[:error] = "Please enter your description of why you'd be a good home for this pet(s)" unless @application.update(submit_params)
    elsif params[:pet_id]
      app_pet = Pet.find(params[:pet_id])
      @application.pets << app_pet
    end
    redirect_to "/applications/#{@application.id}"
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

  def submit_params
    params
      .require(:application)
      .permit(:description, :status)
      .with_defaults(status: 'Pending')
  end
end