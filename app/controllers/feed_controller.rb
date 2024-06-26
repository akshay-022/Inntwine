class FeedController < ApplicationController
    before_action :authenticate_user!

    def index
        @root_topics = Topic.where(parent_id: nil).order(id: :asc)
        @post = Post.new
        #top_post = Post.find_by(id: 11)
        user_communities_partof = current_user.user_communities.where(part_of: true)
        user_communities_ids = user_communities_partof.pluck(:topic_id, :organization_id)
        matching_topic_org_pairs = []
        specific_topic_org_pairs = []
        # Iterate over each community id pair (topic_id, organization_id)
        user_communities_ids.each do |topic_id, organization_id|
          # Find the topic_path for the current topic_id
          topic_path = Topic.find_by(id: topic_id)&.topic_path
          # Find all matching topic_ids for this topic_path
          matching_topic_ids = Topic.where('topic_path LIKE ?', "#{topic_path}/%").pluck(:id)
          # Add each matching topic_id along with the current organization_id to the pairs array
          matching_topic_ids.each do |matching_topic_id|
            matching_topic_org_pairs << [matching_topic_id, organization_id]
          end
          specific_topic_org_pairs << [topic_id, organization_id]

        end
        
        @posts = Post.none
        matching_topic_org_pairs.each do |topic_id, organization_id|
          distinct_posts_in_specific_topic = Post.joins(:topics)
                                            .where(organization_id: session[:organization_id], is_private: false, topics: { id: topic_id })
                                            .distinct
          @posts = @posts.or(Post.where(id: distinct_posts_in_specific_topic))
        end

        specific_topic_org_pairs.each do |topic_id, organization_id|
          distinct_posts_in_specific_topic = Post.joins(:topics)
                                            .where(organization_id: session[:organization_id], topics: { id: topic_id })
                                            .distinct
          @posts = @posts.or(Post.where(id: distinct_posts_in_specific_topic))
        end

        
        

        # Find the Post with id 12
        #post_pin = Post.find(12)
        
        post_pin = Post.find_by_id(12)

        
        
        # Remove the Post with id 11 from @posts if it's already in the array
        #@posts.delete(post_11)
        # Append the Post with id 11 at the beginning of the @posts array
        if post_pin.present?
          @posts = @posts.or(Post.where(user_id: current_user.id))
                       .or(Post.where(user_id: Connection.where(follower_id: current_user.id).select(:followed_id), is_private: false))
                       .or(Post.where(user_id: Connection.where(followed_id: current_user.id, mutual: true).select(:follower_id)))
                       .where.not(moderation_status: 'no')
                       .where.not(id: post_pin.id)
                       .order(reposted_at: :desc)
          @posts = @posts.to_a.prepend(post_pin).to_enum
        else
          @posts = @posts.or(Post.where(user_id: current_user.id))
                       .or(Post.where(user_id: Connection.where(follower_id: current_user.id).select(:followed_id), is_private: false))
                       .or(Post.where(user_id: Connection.where(followed_id: current_user.id, mutual: true).select(:follower_id)))
                       .where.not(moderation_status: 'no')
                       .order(reposted_at: :desc)
        end
        
        session[:return_to] = request.referer

        

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
  
    def update_options
      @post = Post.find(params[:id])
      option_id = params[:option_id].to_i
      option_type = params[:option_type]
  
      # Initialize percentages if nil
      initialize_percentages(@post)
  
      # Update the percentages based on the user's click
      if option_type == 'q1'
        current_percentages = update_percentages(@post.q1_percentages, option_id)
        @post.q1_percentages = current_percentages
      elsif option_type == 'q2'
        current_percentages = update_percentages(@post.q2_percentages, option_id)
        @post.q2_percentages = current_percentages
      end
      if @post.save
        total = current_percentages.split(',').map(&:to_i).sum.to_f
        normalized_percentages = current_percentages.split(',').map(&:to_i).map { |percentage| (percentage / total * 100).round(2) }
        render json: { success: true, percentages: normalized_percentages }
      else
        render json: { success: false, errors: @post.errors.full_messages }
      end
    end
  
    def initialize_percentages(post)
      post.q1_percentages ||= Array.new(post.q1_args.split(',').length, 0).join(',')
      post.q2_percentages ||= Array.new(post.q2_args.split(',').length, 0).join(',')
    end
  
    private
  
    def update_percentages(current_percentages, option_id)
      # Update the percentages based on the user's click
      # Implement your logic to update the percentages string
      # For simplicity, you can split the string, update the corresponding value, and join it again
      percentages = current_percentages.split(',').map(&:to_i)
      percentages[option_id] += 1
      percentages.join(',')
    end
  
      def post_params
        if params[:topic_id].blank?
          params.require(:post).permit(:body, :post_id, :q1, :q2, :q1_args, :q2_args, :image_link, :video_link, :form_link, :datathing, :post_category).merge(organization_id: session[:organization_id], topic_id: 0)
        else
          params.require(:post).permit(:body, :post_id, :q1, :q2, :q1_args, :q2_args, :image_link, :video_link, :form_link, :datathing, :post_category).merge(organization_id: session[:organization_id], topic_id: params[:topic_id])
        end
      end
end
