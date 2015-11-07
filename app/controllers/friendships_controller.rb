class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :edit]

  # get an index of the friends that the user request friendship to
  def pending
    user = User.find_by_authentication_token(params[:auth_token])
    friends = user.pending_friends
    render_jbuilders(friends) do |json,friend|
      friend.to_json json
    end
  end

  # get an index of the friends that request friendship to the user
  def requests
    user = User.find_by_authentication_token(params[:auth_token])
    friends = user.requested_friendships
    render_jbuilders(friends) do |json,friend|
      friend.to_json json
    end
  end

  def friends
    user = User.find_by_authentication_token(params[:auth_token])
    friends = user.friends
    render_jbuilders(friends) do |json,friend|
      friend.to_json json
    end
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
  end

  # GET /friendships/new
  def new
    @friendship = Friendship.new
  end

  # GET /friendships/1/edit
  def edit
  end

  # POST /friendships
  # POST /friendships.json
  def create
    friend_email = params[:email]
    friend = User.find_by_email(friend_email)

    #return if no such user
    if friend.nil?
      render_error_json FriendDoesNotExistsError.new
      return
    end

    friend_id = friend.id

    @friendship = current_user.friendships.build(:friend_id => friend_id, approved: "false")

    if @friendship.save
      tokens = DeviceService.tokens_by_user(friend_id)
      notification = friend.notifications.create(item_type: 'friendship',
                                                   item_id: @friendship.id,
                                                   item_name: 'Friend Request',
                                                   message: friend.username.to_s + ' wants to be your friend!')

      NotificationService.send_notification_by_user(notification.id, tokens)
      head_ok
    else
      render_error_json FriendRequestExistsError.new
    end
  end

  def update

    @friendship = Friendship.where(friend_id: params[:user_id], user_id: params[:friend_id]).first
    @friendship.update(approved: true)

    if @friendship.save
      head_ok
    else
      render_error_json FriendRequestApproveError.new
    end


    # respond_to do |format|
    #   if @friendship.save
    #     # format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @friendship }
    #   else
    #     # format.html { render :edit }
    #     format.json { render json: @friendship.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = Friendship.where(friend_id: [params[:user_id], params[:friend_id]]).where(user_id: [params[:user_id], params[:friend_id]]).last
    @friendship.destroy

    if @friendship.destroy
      head_ok
    else
      render_error_json FriendRequestApproveError.new
    end

    # respond_to do |format|
    #   format.html { redirect_to friendships_url, notice: 'Friendship was successfully destroyed.' }
      # format.json { head :no_content }
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id, :approved)
  end
end
