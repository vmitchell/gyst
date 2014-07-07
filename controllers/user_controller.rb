get "/" do
    @users = User.all
    @tasks = Task.all
    haml :index
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
    user.password_hash = BCrypt::Password.create(params[:password])
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
    if user.id == params[:user_id].to_i
        user.update(name: params[:name])
        user.update(password_hash: BCrypt::Password.create(params[:password]))
        user.update(timezone: params[:timezone])
        if user.save
            session[:username] = user.username
            session[:password] = user.password
            redirect user_page
        else
            @errors = user.errors.full_messages
            haml :edit_user
        end
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
        @errors = ['WRONG, lousy guess']
        haml :create_user
    end
end

get '/logout' do
    session.clear
    redirect '/'
end
