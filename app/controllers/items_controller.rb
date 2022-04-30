class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

  def index
    if params[:user_id]
      items = User.find(params[:user_id]).items
    else
      items = Item.all
    end
    render json: items, include: :user, status: :accepted

  end

  def show
    items = User.find(params[:user_id]).items
    item = items.find(params[:id])
    render json: item, status: :accepted
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(item_params)
    render json: item, status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_error
    render json: {error: "That user_id doesn't exist."}, status: :not_found
  end

end
