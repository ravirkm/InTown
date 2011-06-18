require 'date'

desc "This task is called by the Heroku cron add-on"
  task :cron => :environment do
    init_mail_reminders
  end 

  def init_mail_reminders
    puts "Initiating mail_reminders.."
    # cast relevant dates to strings
    t = Date.today
    today = t.to_s
    tomorrow = (t + 1).to_s
    two_weeks = (t + 14).to_s
    month = t.next_month.to_s
    
    # build arrays of events based on date
    todays_events = Event.where("date = ?", today)
    tomorrows_events = Event.where("date = ?", tomorrow)
    two_weeks_events = Event.where("date = ?", two_weeks)
    month_events = Event.where("date = ?", month)
    #added_today = Event.where("created_at.to_date.to_s = ?", today) #needs fixing
    added_today = Event.where(:created_at => (t - 1))
    
    # send mail to users for each array
    send_mail(todays_events,'reminder')
    send_mail(tomorrows_events,'reminder')
    send_mail(two_weeks_events,'reminder')
    send_mail(month_events,'reminder')
    send_mail(added_today,'alert') 
  end
		
  def send_mail(event_set,type)
    for e in event_set
      c = Company.find_by_id(e.company_id)
      puts "#{c.company_name} is having an event 'soon'!"
      users_near = c.users.select{ |u| u.distance_from(e.to_coordinates) <= u.radius}
      remote_users_near = c.remote_users.select { |r| r.distance_from(e.to_coordinates) <= 30}
      users_near.each do |u|
        puts "User #{u.name} is in range, Mailing!"
	type = 'reminder' ? UserMailer.event_reminder(u,c,e).deliver : UserMailer.event_alert(u,c,e).deliver
      end
      remote_users_near.each do |r|
        puts "Remote User #{r.email} is in range, Mailing!"
	type = 'reminder' ? RemoteUserMailer.event_reminder(r,c,e).deliver : RemoteUserMailer.event_alert(r,c,e).deliver
      end
    end
  end
  
		
		
