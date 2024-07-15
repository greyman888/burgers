class ModificationsController < ApplicationController
  # before_action :set_modification, only: %i[ edit destroy ]

  def create
    @modification = Modification.new(modification_params)
    @modification.save
    redirect_to edit_order_url(@modification.selection.order)
  end

  # def destroy
  #   order = @modification.order
  #   @modification.destroy
  #   redirect_to edit_order_url(order)
  # end

  # def edit
  #   @items = Item.where(category: ["Addition", "Subtraction"])
  #   @modification = Modification.new
    
  # end

  private

  # def set_modification
  #   @modification = modification.find(params[:id])
  # end

  def modification_params
    params.require(:modification).permit(:selection_id, :item_id)
  end
end
