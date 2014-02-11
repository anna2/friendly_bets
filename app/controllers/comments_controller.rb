class CommentsController < ApplicationController
  def create
    @bet = Bet.find(params[:bet_id])
    @comment = @bet.comments.create(comment_params)
    @comment.update(user_id: current_user.id)
    redirect_to bet_path(@bet)
  end

  private

  def comment_params
    params.require(:comment).permit(:photo, :text)
  end

end
