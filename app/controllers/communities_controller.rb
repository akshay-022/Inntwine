class CommunitiesController < ApplicationController
  before_action :set_community, only: %i[ show edit update destroy ]

  # GET /communities or /communities.json
  def index
    @communities = Community.all
    @root_topics = Topic.where(parent_id: nil)
    if params[:topic_id]=='0'
      @posts = Post.where(organization_id: session[:organization_id]) 
    else
      @posts = Post.where(organization_id: session[:organization_id], topic_id: params[:topic_id]) 
    end
    @posts = @posts.order(created_at: :desc)
    @topic = Topic.find_by(id: params[:topic_id])
    @organization = Organization.find_by(id: session[:organization_id])
    @profile = current_user
    @topic_id = params[:topic_id]
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
