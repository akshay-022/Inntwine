class ModeratorsController < ApplicationController
  before_action :set_moderator, only: %i[ show edit update destroy ]

  # GET /moderators or /moderators.json
  def index
    @moderators = Moderator.all
  end

  # GET /moderators/1 or /moderators/1.json
  def show
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
    @moderator.destroy

    respond_to do |format|
      format.html { redirect_to moderators_url, notice: "Moderator was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /moderators/1/show_all
  def show_all
    # Ensure user is authenticated
    unless current_user.is_moderator? || current_user.admin?
      # Redirect or handle unauthorized access
      redirect_to root_path, alert: "You are not authorized to view this page."
      return
    end

    # Your custom logic for show_all
    if current_user.admin
      @posts = Post.all
                .where(moderation_status: 'pending')  
    elsif current_user.is_moderator
      @posts = Post.joins(:moderator_posts)
                .where(moderator_posts: { moderator_id: current_user.id })
                .where(topic_id: params[:topic_id], organization_id: params[:organization_id])
                .where(moderation_status: 'pending')
                .order(created_at: :desc)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moderator
      @moderator = Moderator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def moderator_params
      params.require(:moderator).permit(:user_id, :community_id)
    end
end
