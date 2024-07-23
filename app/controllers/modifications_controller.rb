class ModificationsController < ApplicationController
  before_action :set_modification, only: %i[ destroy ]

  def create
    @modification = Modification.new(modification_params)
    @modification.save
    redirect_to edit_order_url(@modification.selection.order)
  end

  def destroy
    order = @modification.selection.order
    @modification.destroy
    redirect_to edit_order_url(order)
  end

  private

  def set_modification
    @modification = Modification.find(params[:id])
  end

  def modification_params
    params.require(:modification).permit(:selection_id, :item_id)
  end
end
