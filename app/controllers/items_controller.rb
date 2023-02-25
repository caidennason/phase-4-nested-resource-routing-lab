class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    # if :user == true 
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    return render json: items, include: :user
    # else
    #   render_not_found_response
    # end
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    render json: item
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create(params.permit(:name, :description, :price))
    render json: item, status: :created
  end

  private

  def render_not_found_response
    render json: { error: "Item not found" }, status: :not_found
  end

end
