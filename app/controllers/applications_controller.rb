class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @applicationpets = @application.pets
  end

  def new
    
  end
end