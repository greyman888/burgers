class SelectionsController < ApplicationController
  before_action :set_selection, only: %i[ edit change update destroy ]

  def new
    @order = Order.find(params[:order])
    @items = Item.all
    @selection = Selection.new
    render "select_item"
  end

  def create
    @selection = Selection.new(selection_params)
    @selection.save
    if @selection.item.category == "Meal"
      order = @selection.order
      burger = Item.where(name: @selection.item.name, category: "Burger").first
      @selection.meal_selections.create(item: burger, order: order)
      size = @selection.item.size
      side = Item.find_by(category: "Side", name: "Fries", size: size)
      @selection.meal_selections.create(item: side, order: order)
      drink = Item.find_by(category: "Drink", name: "Cola", size: size)
      @selection.meal_selections.create(item: drink, order: order)
    end
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

  def change
    @items = Item.where(category: ["Side", "Drink"])
    @order = @selection.order
    render "select_item"
  end

  def update
    @selection.update(selection_params)
    redirect_to edit_order_url(@selection.order)
  end

  private

  def set_selection
    @selection = Selection.find(params[:id])
  end

  def selection_params
    params.require(:selection).permit(:order_id, :item_id)
  end
end
