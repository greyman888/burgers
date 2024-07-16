class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  def index
    @orders = Order.all
  end

  def new
    @order = Order.create
    @selections = []
    render "edit"
  end

  def edit
    @selections = @order.selections.includes(:item, :modifications => :item, :meal_selections => :item)
  end

  def show
    
  end

  def update
    
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:chunk)
  end
end
