post "/task/create" do
    circle_name = params[:circle]
    circle = logged_in_user.circles.find_by_name circle_name
    if circle.nil?
        show_message "Please create a circle first."
        redirect user_page
    else
        task = Task.new
        task.name = params[:name]
        task.location = params[:location]
        # task.due = params[:due]
        logged_in_user.tasks << task
        circle.tasks << task
    end
    if task.save
      session[:message] = 'Creation of the task was successfull, my lord.'
      redirect user_page
    else

      session[:message] = task.errors
      redirect user_page
    end
end

get "/task/:task_id/edit" do
    @task = logged_in_user.tasks.find_by_id params[:task_id]
    haml :edit_task
end

post  "/task/:task_id/edit" do
    task = logged_in_user.tasks.find_by_id "#{params[:task_id]}"
    task[:name] = params[:name]
    task[:location] = params[:location]
    circle = logged_in_user.circles.find_by_name params[:circle]
    circle.tasks << task
    if task.save
        session[:message] = 'Your task was successfully edited.'
        redirect "/task/#{task.id}/edit"
    else
        session[:message] = "WRONG"
    end
end

get "/task/:task_id/delete" do
    task = logged_in_user.tasks.find_by_id "#{params[:task_id]}"
    logged_in_user.tasks.find(task.id).destroy
    session[:message]  = "Task has been cultivated successfully."
    redirect user_page
end