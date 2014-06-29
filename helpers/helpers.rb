configure do
  enable :sessions
  set :session_secret, 'secret'
  set :haml, :layout => :'/layout'
end

before do
  is_logged_in? ? session[:username] : session[:username] = "Task Friend"     
end

helpers do 
  NO_LOGIN = "You need to have account, please log in or sign up" 
  DEFAULT_USERNAME = "Task Friend"

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

def debug object
    if object.class.to_s.downcase == 'array'
        object.inspect
    else
        object.attributes
    end
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

end