class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :edit, :update, :destroy]

  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all
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
x
  # POST /friendships
  # POST /friendships.json
  def create
    friend_email = params[:email]
    friend_id = User.find_by_email friend_email

    @friendship = current_user.friendships.build(:friend_id => friend_id, approved: "false")

    respond_to do |format|
      if @friendship.save
        # format.html { redirect_to @friendship, notice: 'Friendship was successfully created.' }
        format.json { render :show, status: :created, location: @friendship }
      else
        # format.html { render :new }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update

    @friendship = Friendship.where(friend_id: current_user, user_id: params[:id]).first
    @friendship.update(approved: true)


    respond_to do |format|
      if @friendship.save
        # format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
        format.json { render :show, status: :ok, location: @friendship }
      else
        # format.html { render :edit }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).where(user_id: [current_user, params[:id]]).last
    @friendship.destroy

    respond_to do |format|
      # format.html { redirect_to friendships_url, notice: 'Friendship was successfully destroyed.' }
      format.json { head :no_content }
    end
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