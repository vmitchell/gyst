post "/task/create" do
    @task = Task.new
    @task.attributes = params
    logged_in_user.tasks << @task
    if @task.save
      session[:message] = 'Creation of the task was successfull, my lord.'
      redirect "/user/#{logged_in_user.id}"
    else
      session[:message] = 'Crasdasdasdsa'
      redirect "/user/#{logged_in_user.id}"
    end
end

get "/task/:task_id/edit" do
    @task = Task.find_by_id "#{params[:task_id]}"
    haml :edit_task
end

post  "/task/:task_id/edit" do
    @task = Task.find_by_id "#{params[:task_id]}"
    @task[:name] = params[:name]
    if @task.save
       session[:message] = 'Your task was successfully edited.'
       redirect "/user/#{logged_in_user.id}"
    else
       session[:message] = "WRONG"
    end
end

get "/task/:task_id/delete" do
    @task = Task.find_by_id "#{params[:task_id]}"
    Task.find(@task.id).destroy
    session[:message]  = "Task has been cultivated successfully."
    redirect "/user/#{logged_in_user.id}"
end