class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ show edit update destroy ]

  # GET /organizations or /organizations.json
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1 or /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  def switch_organization
    organization_id = params[:organization_id]
    # Perform validation or authorization checks if necessary
    # ...
    @profile = current_user
    indic = 0
    @profile.user_organizations.each do |user_organization|
      if user_organization.organization_id == organization_id.to_i
        session[:organization_id] = organization_id
        flash[:notice] = "Switched to organization #{user_organization.organization.organization_name}"
        indic = 1
      end
    end
    if indic == 0
      flash[:notice] = "You cannot access this organization yet."
    end
    redirect_back(fallback_location: root_path)
  end


  # GET /organizations/1/edit
  def edit 
  end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to organization_url(@organization), notice: "Organization was successfully created." }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to organization_url(@organization), notice: "Organization was successfully updated." }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url, notice: "Organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:organization_path, :organization_name, :organization_email)
    end
end
