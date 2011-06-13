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

  # could be dryer
  def mail_reminders(interval='today')
    puts "Initiating mail_reminders.."
	  if interval == 'today'
	    today = Date.today.to_s
		todays_events = Event.where("date = ?", today)
        unless todays_events.all.size == 0
        puts "At least one company is having an event today!"
        for e in todays_events
          c = Company.find_by_id(e.company_id)
          puts "#{c.company_name} is having an event today!"
          users_near = c.users.select{ |u| u.distance_from(e.to_coordinates) <= u.radius}
          users_near.each do |u|
			puts "#{u.name} is in range, Mailing!"
			UserMailer.reminder_today(u,c,e).deliver
          end
        end
      else
        puts "No companies are having events today!"
      end
		elsif interval == 'tomorrow'
		  tomorrow = (Date.today + 1).to_s
			tomorrows_events = Event.where("date == ?", tomorrow)
			unless todays_events.all.empty?
        for e in todays_events
          @event = e
          @company = Company.find_by_id(@event.company_id)
          if @company.users.empty?
            #puts "No user is following #{@company.company_name}."
            #@user = User.new(:name => "No one")
          else
            for user in @company.users.near(@event.address,100) #user_dist
              @user = user
              puts "#{@user.name} is in range, Mailing!"
              UserMailer.reminder_today(@user).deliver
            end
          end
        end
      end
		elsif interval == 'two weeks'
		  two_weeks = (Date.today + 14).to_s
			two_weeks_events = Event.where("Date.parse(date) == ?", two_weeks)
			unless todays_events.all.empty?
        for e in todays_events
          @event = e
          @company = Company.find_by_id(@event.company_id)
          if @company.users.empty?
            #puts "No user is following #{@company.company_name}."
            #@user = User.new(:name => "No one")
          else
            for user in @company.users.near(@event.address,10) #user_dist
              @user = user
              puts "#{@user.name} is in range, Mailing!"
              UserMailer.reminder_today(@user).deliver
            end
          end
        end
      end
	end		
  end


  
  private
   

    def authorized_company
      @event = Event.find(params[:id])
      redirect_to root_path unless current_company.id = (@event.company.id)
    end
end

    
    
