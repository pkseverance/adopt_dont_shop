class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alpha_order_by_name
  end
end