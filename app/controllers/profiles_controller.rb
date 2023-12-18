class ProfilesController < ApplicationController
  def show
    @profile = User.find(params[:id])
    session[:return_to] = request.referer
  end
  def search
    query = params[:query]
    @search_results = User.where("username LIKE ? OR first_name LIKE ? OR last_name LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    # Render a partial view for the search results
    respond_to do |format|
      format.js { render partial: 'search_results' } # _search_results.html.erb
    end
  end
end
