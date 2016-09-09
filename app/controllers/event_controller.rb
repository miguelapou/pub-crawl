class EventController < ApplicationController

  before_action :is_authenticated, only: [:new,:create]

  def index
    @events = Event.all
  end

  def new
  end

  def create
    # puts event_params.inspect
    # puts event_params.[:image].path
    @current_user = User.find(session[:user_id])
    #latest_event = Event.create(event_params)
    # redirect_to event_path(latest_event)

    uploaded_file = event_params[:image].path
    cloudinary_file = Cloudinary::Uploader.upload(uploaded_file)
       # render json: cloudinary_file
    new_event = {
      :name => event_params[:name],
      :date => event_params[:date],
      :time => event_params[:time],
      :image => cloudinary_file['public_id'],
      :location_ids => event_params[:location_ids]
    }
    current_event = Event.create(new_event)
    redirect_to event_path(current_event)

  end

  def update

  end

  def delete
  end

  def show
    @event = Event.find(params[:id])
  end

  def addlocation
    current_event = Event.find(params[:id])
    current_event.locations.create(location_params)
    redirect_to event_path(Event.find(params[:id]))
  end

  private

  def event_params
    params.require(:event).permit(:name, :date, :time, :image, :location_ids => [])
  end

  def location_params
    params.require(:location).permit(:name, :address, :latitude, :longitude, :arrivetime, :departtime)
  end


end
