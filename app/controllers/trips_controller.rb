class TripsController < ApplicationController

  def create
    user_id = params[:user_id]
    trip = TripService.create(user_id, params)

    render_jbuilder do |json|
      trip.to_json(json)
    end
  end

end