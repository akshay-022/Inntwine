class CommunitiesController < ApplicationController
  before_action :set_community, only: %i[ show edit update destroy ]

  # GET /communities or /communities.json
  def index
    @communities = Community.all
    @root_topics = Topic.where(parent_id: nil)
    top_post = Post.find_by(id: 11)
    session[:return_to] = request.referer
    if params[:topic_id]=='0'
      remaining_posts = Post.where(organization_id: session[:organization_id], is_private: false)
              .or(Post.where(organization_id: session[:organization_id], topic_id: 0))
      #@posts = top_post ? top_post.class.from("(#{top_post.to_sql}) UNION (#{remaining_posts.to_sql})") : remaining_posts
      @posts = remaining_posts
      #@posts = Post.where(organization_id: session[:organization_id]) 
    else
      #Find all topic_ids that are substring.
      #Add a make visible to supercommunities checkbox.
      topic = Topic.find_by(id: params[:topic_id])
      if topic
        # Find all topics whose topic_path starts with the found topic_path
        matching_topics = Topic.where('topic_path LIKE ?', "#{topic.topic_path}%")
        matching_topic_ids = matching_topics.pluck(:id)
        # Get posts that belong to any of the matching topics
        posts_in_matching_topics = Post.where(organization_id: session[:organization_id], is_private: false, topic_id: matching_topic_ids)
        #posts_in_matching_topics = Post.where(organization_id: session[:organization_id], topic_id: matching_topic_ids)
        posts_in_specific_topic = Post.where(organization_id: session[:organization_id], topic_id: topic.id)
        @posts = posts_in_matching_topics.or(posts_in_specific_topic)
      end
    end
    @posts = @posts.where.not(moderation_status: 'no').order(created_at: :desc)
    @topic = Topic.find_by(id: params[:topic_id])
    @organization = Organization.find_by(id: session[:organization_id])
    @profile = current_user
    @topic_id = params[:topic_id]
    @is_moderator = Moderator.find_by(
      topic_id: params[:topic_id],
      organization_id: session[:organization_id],
      user_id: current_user.id
    ).present?

    # Check if there is a moderator request for the user
    @is_moderator_request = ModeratorRequest.find_by(
      topic_id: params[:topic_id],
      organization_id: session[:organization_id],
      user_id: current_user.id
    ).present?
  end

  # GET /communities/1 or /communities/1.json
  def show
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
  end

  def join_community
    @topic_id = params[:topic_id]
    @topic = Topic.find_by(id: params[:topic_id])
    @organization = Organization.find_by(id: session[:organization_id])
    # Ensure the user is signed in
    return redirect_to root_path, alert: 'Please sign in to join the community.' unless user_signed_in?

    user_community = UserCommunity.find_by(user: current_user, organization: @organization, topic: @topic)

    if user_community
      user_community.destroy
      redirect_to communities_path(topic_id: @topic_id), notice: 'Exited the community successfully.'
      flash.discard
    else
      # Create a UserCommunity entry
      UserCommunity.create(user: current_user, organization: @organization, topic: @topic)
      redirect_to communities_path(topic_id: @topic_id), notice: 'Joined the community successfully.'
      flash.discard
    end
  end

  # POST /communities or /communities.json
  def create
    @community = Community.new(community_params)

    respond_to do |format|
      if @community.save
        format.html { redirect_to community_url(@community), notice: "Community was successfully created." }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1 or /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to community_url(@community), notice: "Community was successfully updated." }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communities/1 or /communities/1.json
  def destroy
    @community.destroy

    respond_to do |format|
      format.html { redirect_to communities_url, notice: "Community was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def community_params
      params.require(:community).permit(:name, :description, :organization_id, :topic_id, :privacy_id, :moderators_id)
    end
end
