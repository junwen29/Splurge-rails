class TripsController < ApplicationController

  def create
    user_id = params[:user_id]
    trip = TripService.create(user_id, params)

    render_jbuilder do |json|
      trip.to_json(json)
    end
  end

  def index
    user = User.find(params[:user_id])
    trips = user.trips

    render_jbuilders(trips) do |json,trip|
      trip.to_json(json)
    end

  end

end