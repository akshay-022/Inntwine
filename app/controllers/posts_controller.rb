class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc)
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.turbo_stream
      else
        format.html do
          flash[:post_errors] = @post.errors.full_messages
          redirect_to root_path
        end
      end
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :desc)
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
  end

  def repost
    @post = Post.find(params[:id])

    @repost = current_user.posts.new(post_id: @post.id)

    respond_to do |format|
      if @repost.save
        format.turbo_stream
      else
        format.html { redirect_back fallback_location: @post, alert: "Could not repost" }
      end
    end
  end


  private

    def post_params
      params.require(:post).permit(:body, :post_id)
    end
end
