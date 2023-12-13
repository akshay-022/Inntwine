class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
      # Check if the comment has a parent_comment_id
      parent_comment_id = comment_params[:parent_comment_id]
     if parent_comment_id.present?
       # Create a reply to an existing comment
       parent_comment = Comment.find(parent_comment_id)
       @comment = @post.comments.new(comment_params.merge(user: current_user))
     else
       # Create a new top-level comment
       @comment = @post.comments.new(comment_params.merge(user: current_user))
     end
 
     respond_to do |format|
       if @comment.save
         format.turbo_stream
       else
         format.html { redirect_to post_path(@post), alert: "Reply could not be created" }
       end
     end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to post_path(@post), notice: "Comment was deleted" }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_comment_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
