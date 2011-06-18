require 'geocoder'
require 'date'
class UserMailer < ActionMailer::Base
  default :from => "eventalertss@gmail.com"
  
  def event_reminder(user,company,event)
    @today = Date.today
    @user = user
    @lat = user.latitude
    @long = user.longitude
    @host = "intown.heroku.com"
    @company = company
    @event = event
	  @midpoint =  "#{Geocoder::Calculations.geographic_center([@event, @user])}".gsub('[','').gsub(']','')
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "#{@company.company_name} is having an event near you!")
  
  end
  
end
