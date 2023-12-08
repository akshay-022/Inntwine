class UserOrganizationsController < ApplicationController
  before_action :set_user_organization, only: %i[ show edit update destroy ]

  # GET /user_organizations or /user_organizations.json
  def index
    @user_organizations = UserOrganization.all
  end

  # GET /user_organizations/1 or /user_organizations/1.json
  def show
  end

  # GET /user_organizations/new
  def new     #Can add a new organization for yourself with a button
    @user_organization = UserOrganization.new
  end

  # GET /user_organizations/1/edit
  def edit
  end

  # POST /user_organizations or /user_organizations.json
  def create
    @user_organization = UserOrganization.new(user_organization_params)

    respond_to do |format|
      if @user_organization.save
        format.html { redirect_to user_organization_url(@user_organization), notice: "User organization was successfully created." }
        format.json { render :show, status: :created, location: @user_organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_organizations/1 or /user_organizations/1.json
  def update
    respond_to do |format|
      if @user_organization.update(user_organization_params)
        format.html { redirect_to user_organization_url(@user_organization), notice: "User organization was successfully updated." }
        format.json { render :show, status: :ok, location: @user_organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_organizations/1 or /user_organizations/1.json
  def destroy
    @user_organization.destroy

    respond_to do |format|
      format.html { redirect_to user_organizations_url, notice: "User organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_organization
      @user_organization = UserOrganization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_organization_params
      params.require(:user_organization).permit(:user_id, :organization_id)
    end
end
