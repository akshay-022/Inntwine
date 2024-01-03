class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    @posts = Post.all.where.not(moderation_status: 'no')
                .order(created_at: :desc)
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        topic = Topic.find_by(id: params[:topic_id])
        # Associate the post with the topic if the topic exists
        @post.topics << topic if topic.present?
        increment_user_community_entry(params[:topic_id], 1)
        if @post.is_private == false && params[:topic_id] != '0'
          topic_id_to_add = 0
          topic = Topic.find_by(id: topic_id_to_add)
          @post.topics << topic if topic.present?
          increment_user_community_entry(0, 1)
        end
        format.turbo_stream
      else
        format.html do
          flash[:post_errors] = @post.errors.full_messages
          redirect_to root_path
        end
      end
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      @post.update(moderation_status: "pending")
      redirect_to root_path, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :desc)
    set_referring_url
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

  def repost_post
    # Ensure user is authenticated
    @root_topics = Topic.where(parent_id: nil).order(id: :asc)
    @posts = Post.where(user_id: current_user.id)
            .where.not(id: Post.joins(:topics).where(topics: { id: params[:topic_id] }))
            .order(reposted_at: :desc)
  end

  def submit_repost
    original_post = Post.find(params[:post_id])
    if original_post.topics.exists?(params[:topic_id])
      # The original post already belongs to the specified topic
      flash[:notice] = "This post has already been posted here before."
    else
      # Add the topic to the original post's topics
      topic = Topic.find(params[:topic_id])
      original_post.topics << topic
      original_post.update(moderation_status: "pending")
      original_post.update(reposted_at: Time.now)
      increment_user_community_entry(params[:topic_id], 1)
      flash[:notice] = "Repost successful!"
    end
    redirect_to communities_path(topic_id: params[:topic_id]), turbolinks: false
  end

  def update_options
    @post = Post.find(params[:question_id])
    option_id = params[:option_id].to_i
    option_type = params[:option_type]

    # Initialize percentages if nil
    initialize_percentages(@post)

    # Update the percentages based on the user's click
    if option_type == 'q1'
      current_percentages = update_percentages(@post.q1_percentages, option_id)
      # Create a new vote record for the user, post, question_id, and option_id
      @vote = Vote.create(user: current_user, post: @post, question_id: 1, option_id: option_id)
      @post.q1_percentages = current_percentages.join(",")
    elsif option_type == 'q2'
      current_percentages = update_percentages(@post.q2_percentages, option_id)
      @vote = Vote.create(user: current_user, post: @post, question_id: 2, option_id: option_id)
      @post.q2_percentages = current_percentages.join(",")
    end
    if @post.save
      total = current_percentages
      normalized_percentages = total.map { |percentage| (percentage * 100.0 / total.sum).round(2) }
      render json: { success: true, percentages: normalized_percentages }
    else
      render json: { success: false, errors: @post.errors.full_messages }
    end
  end

  def initialize_percentages(post)
    post.q1_percentages ||= Array.new(post.q1_args.split(',').length, 0).join(',')
    post.q2_percentages ||= Array.new(post.q2_args.split(',').length, 0).join(',')
  end

  def moderation
    @post = Post.find(params[:id])
    status = params[:status]

    if %w(yes no).include?(status)
      @post.update(moderation_status: status)
      # You can add additional logic if needed

      if status == "no"
        @post.topics.each do |topic|
          increment_user_community_score(topic.id, -1) # Decrement score
        end
      end

      redirect_to moderator_show_all_path(user_id: current_user.id), notice: 'Moderation status updated.'
    else
      redirect_to moderator_show_all_path(user_id: current_user.id), notice: 'Seems to be some error.'
    end
  end

  private

  def set_referring_url
    session[:return_to] = request.referer
  end

  def update_percentages(current_percentages, option_id)
    # Update the percentages based on the user's click
    # Implement your logic to update the percentages string
    # For simplicity, you can split the string, update the corresponding value, and join it again
    percentages = current_percentages.split(',').map(&:to_i)
    percentages[option_id] += 1
    percentages.join(',')
    return percentages
  end

    def post_params
      if params[:topic_id].blank?
        params.require(:post).permit(:body, :post_id, :q1, :q2, :q1_args, :q2_args, :image_link, :video_link, :form_link, :datathing, :is_private, post_category: []).merge(organization_id: session[:organization_id])
      else
        params.require(:post).permit(:body, :post_id, :q1, :q2, :q1_args, :q2_args, :image_link, :video_link, :datathing, :form_link, :is_private, post_category: []).merge(organization_id: session[:organization_id])
      end
    end

  def increment_user_community_entry(topic_idx, k)
    topic = Topic.find(topic_idx)
    parent_topic_ids = topic.topic_path.split('/').map(&:to_i)
    parent_topic_ids.each do |topic_id|
      user_community = UserCommunity.find_by(
        user_id: current_user.id,
        organization_id: session[:organization_id],
        topic_id: topic_id
      )
      if user_community
        if k>0
          user_community.increment!(:score, 1)
        else
          user_community.decrement!(:score, 1)
        end
        
      else
        if k>0
          UserCommunity.create(
            user_id: current_user.id,
            organization_id: session[:organization_id],
            topic_id: topic_id,
            part_of: (topic_id != 0),
            score: 1
          )
        else
          UserCommunity.create(
            user_id: current_user.id,
            organization_id: session[:organization_id],
            topic_id: topic_id,
            score: -1
          )
        end
      end
    end
  end

  
end
