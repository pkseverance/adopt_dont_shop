class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alpha_order_by_name
    pending_apps = Application.all.where("status like ?", "%Pending%")
    pending_pets = pending_apps.map {|app| app.pets}.flatten
    @pending_shelters = pending_pets.map {|pet| pet.shelter}
  end
end