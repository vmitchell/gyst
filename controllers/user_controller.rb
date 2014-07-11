require 'evernote_oauth'

get "/" do
    @users = User.all
    @tasks = Task.all
    haml :index
end

get "/evernote/notes" do
    @users = User.all
    @tasks = Task.all
    @content = []
    @notes.notes.each do |note|
    @debug = Time.at(note.attributes.reminderTime/1000).in_time_zone logged_in_user.timezone
    @content << note_store.getNoteContent(token, note.guid)
    end
    haml :index
end

get '/evernote' do
    client = EvernoteOAuth::Client.new
    request = client.request_token oauth_callback: "http://localhost:4567/evernote/auth"
    session[:request] = request
    redirect request.authorize_url
end

get '/evernote/auth' do
    access_token = session[:request].get_access_token(oauth_verifier: params[:oauth_verifier])
    session[:evernote_token] = access_token

    token = session[:evernote_token].token
    client = EvernoteOAuth::Client.new(token: token)
    note_store = client.note_store
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    @notebooks = note_store.listNotebooks  token
    @notes = note_store.findNotes(token, filter, nil, 10) 

    # @content = []
    @notes.notes.each do |note|
        note_time = note.attributes.reminderTime
        defaut_circle = logged_in_user.circles.find_by_name("Evernote tasks")
        if note_time.nil?
        else
            time = Time.at(note_time/1000).in_time_zone logged_in_user.timezone
            if defaut_circle.nil?
                circle  = Circle.create name: "Evernote tasks", creator_id: logged_in_user.id
                logged_in_user.circles << circle
                circle_id = logged_in_user.circles.last.id
                logged_in_user.tasks.create name: note.title, due: time, circle_id: circle_id
                show_message "Your notes from Evernote were succsessfully imported"
            else
                time = Time.at(note_time/1000).in_time_zone logged_in_user.timezone
                logged_in_user.tasks.create name: note.title, due: time, circle_id: defaut_circle.id
                show_message "Your notes from Evernote were succsessfully imported."
            end
        end
        # @content << note_store.getNoteContent(token, note.guid)
    end
    redirect user_page
end

get "/user/:id" do
    @tasks = Task.all
    @user = User.find params[:id]
    haml :detail_user
end

get "/signup" do
    haml :create_user
end

post '/user/create' do
    user = User.create params
    user.timezone 
    user.password_hash = BCrypt::Password.create(params[:password])
    user.picture = rand(1..9)
    if user.save
        session[:username] = user.username
        session[:password] = user.password
        redirect user_page
    else
        @errors = user.errors.full_messages
        haml :create_user
    end
end

get '/user/:user_id/edit' do
    haml :edit_user
end

post '/user/:user_id/edit' do
    user = User.find_by_id logged_in_user.id
    if !params[:password].empty? && params[:password] != params[:password_confirm] 
        show_error "Please make sure your password and it's confirmation match"
        redirect user_page
    end
    if user.id == params[:user_id].to_i && !params[:password].empty?
        user.update(name: params[:name])
        user.update(password_hash: BCrypt::Password.create(params[:password]))
        user.update(timezone: params[:timezone])
        if user.save
            session[:username] = user.username
            session[:password] = user.password
            show_message "Your profile has been edited succsessfully"
            redirect user_page
        end
    else
        session[:error] = user.errors.full_messages
        show_error "Please fill in the password"
        redirect user_page
    end
end

post '/user/login' do
    user = User.find_by_email(params[:email])
    if !user.nil? && user.password == params[:password]
        session[:username] = user.username
        session[:password] = user.password
        logged_in_user
        redirect user_page
    else 
        show_error 'WRONG, lousy guess'
        haml :create_user
    end
end

get '/logout' do
    session.clear
    redirect '/'
end
