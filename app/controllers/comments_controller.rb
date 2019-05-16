class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params['post_id'])
    @comment = @post.comments.build(comment_params)
    binding.pry
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = 'Your comment has been created'
      redirect_to post_path(@post)
    else
      @post = Post.find(params['post_id']) #Added in to make incorrect comment not show
      render 'posts/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
