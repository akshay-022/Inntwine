class ConnectionsController < ApplicationController

  # GET /connections or /connections.json
  def index
    @connections = Connection.where('follower_id = ? OR followed_id = ?', current_user.id, current_user.id)
    @conreqs = Connection.where(followed_id: current_user.id, mutual: false)
    @root_topics = Topic.where(parent_id: nil)
    @organization_name = Organization.find_by(id: session[:organization_id].to_i).organization_name
  end

  # GET /connections/1 or /connections/1.json
  def show
    current_organization_id = session[:organization_id]
    current_topic_id = params[:id]
    moderator_user_ids = Moderator
                    .where(topic_id: current_topic_id, organization_id: current_organization_id)
                    .pluck(:user_id)
    @moderators = User.where(id: moderator_user_ids)
    
    @contributors = User.joins(:user_communities)
                      .where(user_communities: { organization_id: current_organization_id, topic_id: current_topic_id })
                      .order('user_communities.score DESC')
    @root_topics = Topic.where(parent_id: nil)
    @organization_name = Organization.find_by(id: session[:organization_id].to_i).organization_name
  end

  def accept
    connection = Connection.find(params[:id])
    connection.update(mutual: true)
    redirect_to connections_path, notice: 'Connection accepted successfully.'
  end

  def send_connection
    Connection.create(followed_id: params[:followed_id], follower_id: current_user.id, mutual: false)
    redirect_back fallback_location: connections_path, notice: 'Connection request sent successfully.'
  end

end
