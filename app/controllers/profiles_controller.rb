class ProfilesController < ApplicationController
  def show
    @profile = User.find(params[:id])
    session[:return_to] = request.referer
    @existing_conversation = Conversation.between(current_user.id, @profile.id).first
  end
  def search
    query = params[:query]
    @search_results = User.where("username ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    # Render a partial view for the search results
    respond_to do |format|
      format.js { render partial: 'search_results' } # _search_results.html.erb
    end
  end
end
