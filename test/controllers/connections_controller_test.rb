require "test_helper"

class ConnectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @connection = connections(:one)
  end

  test "should get index" do
    get connections_url
    assert_response :success
  end

  test "should get new" do
    get new_connection_url
    assert_response :success
  end

  test "should create connection" do
    assert_difference("Connection.count") do
      post connections_url, params: { connection: { followed_id: @connection.followed_id, follower_id: @connection.follower_id, mutual: @connection.mutual } }
    end

    assert_redirected_to connection_url(Connection.last)
  end

  test "should show connection" do
    get connection_url(@connection)
    assert_response :success
  end

  test "should get edit" do
    get edit_connection_url(@connection)
    assert_response :success
  end

  test "should update connection" do
    patch connection_url(@connection), params: { connection: { followed_id: @connection.followed_id, follower_id: @connection.follower_id, mutual: @connection.mutual } }
    assert_redirected_to connection_url(@connection)
  end

  test "should destroy connection" do
    assert_difference("Connection.count", -1) do
      delete connection_url(@connection)
    end

    assert_redirected_to connections_url
  end
end
