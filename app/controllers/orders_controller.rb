class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit select_item update destroy ]

  def index
    @orders = Order.all
  end

  def new
    @order = Order.create
    
  end

  def select_item
    @items = Item.all
    @selection = Selection.new
  end

  def edit
    @selections = @order.selections.includes(:item, :modifications => :item)
  end

  def show
    
  end

  def update
    
  end

  def destroy
    
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:chunk)
  end
end
