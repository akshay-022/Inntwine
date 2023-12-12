class ProfilesController < ApplicationController
  def show
    @profile = User.find(params[:id])
  end
  def search
    query = params[:query]
    @search_results = User.where("username LIKE ?", "%#{query}%")
    # Render a partial view for the search results
    respond_to do |format|
      format.js { render partial: 'search_results' } # _search_results.html.erb
    end
  end
end
