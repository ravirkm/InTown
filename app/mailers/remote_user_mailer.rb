require 'geocoder'
require 'date'
class RemoteUserMailer < ActionMailer::Base
  default :from => "eventalertss@gmail.com"
  
  def event_reminder(remote_user,company,event)
    @today = Date.today
    @remote_user = remote_user
    @lat = remote_user.latitude
    @long = remote_user.longitude
    @host = "intown.heroku.com"
    @company = company
    @event = event
	  @midpoint =  "#{Geocoder::Calculations.geographic_center([@event, @remote_user])}".gsub('[','').gsub(']','')
    mail(:to => @remote_user.email, :subject => "#{@company.company_name} is having an event near you!")
  
  end
  
end
