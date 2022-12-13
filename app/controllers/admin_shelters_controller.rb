class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alpha_order_by_name
    @pending_shelters = Shelter.pending_shelters
  end
end