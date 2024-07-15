class SelectionsController < ApplicationController
  before_action :set_selection, only: %i[ edit destroy ]

  def create
    @selection = Selection.new(selection_params)
    @selection.save
    redirect_to edit_order_url(@selection.order)
  end

  def destroy
    order = @selection.order
    @selection.destroy
    redirect_to edit_order_url(order)
  end

  def edit
    @items = Item.where(category: ["Addition", "Subtraction"])
    @modification = Modification.new
    
  end

  private

  def set_selection
    @selection = Selection.find(params[:id])
  end

  def selection_params
    params.require(:selection).permit(:order_id, :item_id)
  end
end
