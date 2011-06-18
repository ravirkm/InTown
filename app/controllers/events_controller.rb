require 'date'
class EventsController < ApplicationController
  #before_filter :authenticate_company!, :only => [:create, :destroy]
  before_filter :authorized_company, :only => :destroy

  def edit
    @title = "Edit event"
    @event = Event.find(params[:id])
  end
  
  def create
    @event = current_company.events.build(params[:event])
    if Date.parse(@event.date) < Date.today
      flash[:error] = "This date is in the past! Event not created!"
      redirect_to root_path
    elsif @event.save
      flash[:notice] = "Event created!"
      respond_to do |format| 
        format.html { redirect_to '/' }  
        #format.js   {  }  AJAX creation will have to wait, issues with sorting tables without a redirect 
      end
    else
      flash[:error] = "Invalid date! Event not created!"
      redirect_to root_path
    end
  end
  
  def update
    @event = Event.find(params[:id])
    error = validate_date(@event.date,@event.id)
    puts error
    if error == 'duplicate'
      flash[:error] = "There is already an event on this date! Event not updated!"
      redirect_to edit_event_path(params[:event])
    elsif error == 'past'
      flash[:error] = "This date is in the past! Event not updated!"
      redirect_to edit_event_path(params[:event])
    elsif @event.update_attributes(params[:event])
      flash[:notice] = "Event updated."
      redirect_to '/'
    else
      @title = "Edit event"
      render 'edit'
    end
  end
  
  def index
    @json = Event.all.to_gmaps4rails
  end
    
  def destroy
    @event.destroy
    respond_to do |format|  
      format.html { redirect_to '/' }  
      format.js   {  }  
    end 
  end
  
  private
   

    def authorized_company
      @event = Event.find(params[:id])
      redirect_to root_path unless current_company.id = (@event.company.id)
    end
end

    
    
