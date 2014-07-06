configure do
    enable :sessions
    set :session_secret, 'secret'
    set :haml, :layout => :'/layout'
    Time.zone =  'UTC'
    ActiveRecord::Base.default_timezone = :utc
    # ActiveRecord::Base.time_zone_aware_attributes = true
    # Pony.options = { :from => 'noreply@example.com', :via => :smtp, :via_options => { :host => 'smtp.yourserver.com' } }
end

before do
    is_logged_in? ? Time.zone = logged_in_user.timezone : return
    is_logged_in? ? get_reminders : ""
    is_logged_in? ? session[:username] : session[:username] = "Task Friend"     
end

helpers do 
    NO_LOGIN = "You need to have account, please log in or sign up" 
    DEFAULT_USERNAME = "Task Friend"
    SECTION_IS_PRIVATE = "You need to be logged in to see that secion"

    include Rack::Utils
    alias_method :h, :escape_html

    def title
        @title ?  "#{@title}" : "Annoyer"
    end

    def username
        if is_logged_in?
            logged_in_user.username
        end
    end

    def user_page
        if is_logged_in?
            "/user/#{logged_in_user.id}"
        else
            show_message SECTION_IS_PRIVATE
            "/"
        end
    end

    def is_logged_in?
        session[:username] && session[:password] ?  true : false
    end

      def logged_in_user #execute
        if is_logged_in?
            logged_in_user = User.find_by_username session[:username]
        else
            session[:username] = DEFAULT_USERNAME
        end
    end

    def you
        user = User.find_by_username username
        if  !user.nil? && session[:password] && user.id == params[:id].to_i
            true
        else
            false
        end
    end

    def in_a_circle
      user = User.find_by_username username
        if  !user.nil? && session[:password] && user.circles.find_by_id(params[:circle_id])
          true
        else
          false
        end
    end

    def your_circle circle
        logged_in_user.id == circle.creator_id
    end

    def timezone
        logged_in_user.timezone
    end

    def debug object
        if object.class.to_s.downcase == 'array'
            object.inspect
        else
            object.attributes
        end
    end

    def show_message message
        session.merge!(message: message)
    end

    def include_partial haml_file
        Haml::Engine.new(File.read("./views/#{haml_file}.haml")).render
    end

    def checked key
        @task = Task.all.find_by_id "#{params[:task_id]}"
    end

    def link_to url,text=url,opts={}
        attributes = ""
        opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
        "<a href=\"#{url}\" #{attributes}>#{text}</a>"
    end

    def send_email to, subject, body
         Pony.mail({
            :from => "ibeatnorris@gmail.com",
            :to => to,
            :subject => subject,
            :body => body,
            :via => :smtp,
            :via_options => {
             :address              => 'smtp.mandrillapp.com',
             :port                 => '587',
             :enable_starttls_auto => true,
             :user_name            => 'ibeatnorris@gmail.com',
             :password             => 'u3N2ftAPdFvqZCxHrq2alQ',
             }
        })
    end

    def create_reminder
        Alert.create(
        message: "simple reminder",
        creator_id: logged_in_user.id,
        alert_type: "reminder",
        user_id: logged_in_user.id,
        task_id: params[:task_id].to_i)
    end

    def get_reminders
        reminders_query
    end

    def reminders_query
        reminders = []
        offset = 30*60 #30 min
        if is_logged_in?
            logged_in_user.circles.each do | circle |
                circle.users.each do | user |
                    if user.id != logged_in_user.id
                        circle.tasks.each do | task|
                            remind_time =(task.due.utc - Time.now.utc)/60
                            if ( remind_time <= 30 && remind_time > 0)
                                reminders << task
                            end
                        end
                    end
                end
            end
            reminders.uniq
        end
    end

end