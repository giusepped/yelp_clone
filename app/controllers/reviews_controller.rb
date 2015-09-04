class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.build_review(review_params, current_user)
    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        # Note: if you have correctly disabled the review button where appropriate,
        # this should never happen...
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        # Why would we render new again?  What else could cause an error?
        render :new
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if current_user.id == @review.user_id
      @review.destroy
      flash[:notice] = 'Review deleted successfully'
      redirect_to restaurants_path
    else
      redirect_to restaurants_path
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
