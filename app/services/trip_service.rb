class TripService
  module ClassMethods

    def create(user_id, params)
      trip = Trip.new
      trip.user_id = user_id
      set_trip_params(trip, params)
      trip.save
      trip
    end

    def set_trip_params(trip, params, is_create = true)
      trip.title = params[:title]       if params[:title]
      trip.date      = params[:date]    if params[:date]

      trip.latitude  = params[:latitude]  if params[:latitude]
      trip.longitude = params[:longitude] if params[:longitude]

      trip.city    = params[:city]        if params[:city]
      trip.country = params[:country]     if params[:country]
      trip.state   = params[:state]       if params[:state]
      trip.street  = params[:street]      if params[:street]
      trip.zipcode = params[:zipcode]     if params[:zipcode]
      trip
    end

  end

  class << self
    include ClassMethods
  end

end