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

  
  def update
    
  end
  
  def destroy
    @order.destroy
    redirect_to orders_path
  end
  
  # Voice ordering
  def new_voice
    @order = Order.new
  end
  
  def create
    @order = Order.build(order_params)
    if @order.save
      @order.convert_to_JSON
    end
    redirect_to orders_path
  end
  
  def show
    render "new_voice"
  end
  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:chunk)
  end
end
