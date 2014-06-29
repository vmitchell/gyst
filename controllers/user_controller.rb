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
    if user.save
        session[:username] = user.username
        session[:password] = user.password
        redirect user_page
    else
        "DDD USER CREATE DDDD"
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
        session[:message] = "WRONG, lousy guess."
        redirect "/signup"
    end
end

get '/logout' do
    session.clear
    redirect '/'
end