class SelectionsController < ApplicationController
  def create
    @selection = Selection.new(selection_params)
    @selection.save
    redirect_to edit_order_url(@selection.order)
  end

  def destroy
    @selection = Selection.find(params[:id])
    order = @selection.order
    @selection.destroy
    redirect_to edit_order_url(order)
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def selection_params
    params.require(:selection).permit(:order_id, :item_id)
  end
end
