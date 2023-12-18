class ModeratorsController < ApplicationController
  before_action :set_moderator, only: %i[ show edit update destroy ]

  # GET /moderators or /moderators.json
  def index
    @moderators = Moderator.all
  end

  # GET /moderators/1 or /moderators/1.json
  def show
  end


  def add_moderator_request
    if ModeratorRequest.find_by(topic_id: params[:topic_id], organization_id: session[:organization_id], user_id: current_user.id)
      # User is already a moderator
      flash[:alert] = "Request already sent before."
    else
      # Add the user as a moderator
      ModeratorRequest.create(topic_id: params[:topic_id], user_id: current_user.id, organization_id: session[:organization_id] )
      flash[:notice] = "Request sent successfully."
    end

    redirect_back(fallback_location: communities_path(topic_id: params[:topic_id]))
  end

  # GET /moderators/new
  def new
    @moderator = Moderator.new
  end

  # GET /moderators/1/edit
  def edit
  end

  # POST /moderators or /moderators.json
  def create
    @moderator = Moderator.new(moderator_params)

    respond_to do |format|
      if @moderator.save
        format.html { redirect_to moderator_url(@moderator), notice: "Moderator was successfully created." }
        format.json { render :show, status: :created, location: @moderator }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @moderator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moderators/1 or /moderators/1.json
  def update
    respond_to do |format|
      if @moderator.update(moderator_params)
        format.html { redirect_to moderator_url(@moderator), notice: "Moderator was successfully updated." }
        format.json { render :show, status: :ok, location: @moderator }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @moderator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moderators/1 or /moderators/1.json
  def destroy
    unless current_user.admin
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
    @moderator_remove = Moderator.find_by(user_id: params[:id], topic_id: params[:topic_id], organization_id: session[:organization_id])
    @moderator_remove.destroy
    redirect_back(fallback_location: connection_path(user_id: params[:topic_id]))
  end

  # GET /moderators/1/show_all
  def show_all
    # Ensure user is authenticated
    is_moderator = Moderator.find_by(user_id: current_user.id).present?
    unless is_moderator || current_user.admin?
      # Redirect or handle unauthorized access
      redirect_to root_path, alert: "You are not authorized to view this page."
      return
    end

    # Your custom logic for show_all
    if current_user.admin
      @posts = Post.all
                .where(moderation_status: 'pending')  
    elsif is_moderator
      @posts = Post.where(moderation_status: 'pending')
              .where(organization_id: Moderator.where(user_id: current_user.id)
                                              .pluck(:organization_id))
              .where(topic_id: Moderator.where(user_id: current_user.id)
                                      .pluck(:topic_id))
              .order(created_at: :desc)
    end
    @requests = ModeratorRequest.all
  end

  def add_moderator
    ModeratorRequest.find_by(topic_id: params[:topic_id_mod], organization_id: params[:organization_id], user_id: params[:user_id]).destroy
    if params[:status]=="yes"
      if Moderator.find_by(topic_id: params[:topic_id_mod], organization_id: params[:organization_id], user_id: params[:user_id])
        # User is already a moderator
        flash[:alert] = "Already a moderator."
      else
        # Add the user as a moderator
        Moderator.create(topic_id: params[:topic_id_mod], organization_id: params[:organization_id], user_id: params[:user_id])
        flash[:notice] = "Moderator Added Successfully."
        user = User.find(params[:user_id])
        user.update(is_moderator: true)
      end
    else
      flash[:notice] = "Request deleted."
    end
    redirect_back(fallback_location: moderator_show_all_path(user_id: current_user.id))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moderator
      #@moderator = Moderator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def moderator_params
      params.require(:moderator).permit(:user_id, :community_id, :topic_id, :organization_id)
    end
end
