
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
        due = (Time.zone.parse params[:due]).in_time_zone logged_in_user.timezone
        task.due = due
        logged_in_user.tasks << task
        circle.tasks << task
    end
    if task.save
      session[:message] = "Creation of the task was successfull, my lord. #{task.due.inspect}"
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
    @task = logged_in_user.tasks.find_by_id "#{params[:task_id]}"
    @task.name = params[:name]
    @task.location = params[:location]
    @task.due = (Time.zone.parse params[:due]).in_time_zone logged_in_user.timezone
    circle = logged_in_user.circles.find_by_name params[:circle]
    circle.tasks << @task
    if @task.save
        session[:message] = 'Your task was successfully edited.'
        redirect "/task/#{@task.id}/edit"
    else
        @errors = @task.errors.full_messages
        haml :edit_task
    end
end

get "/task/:task_id/delete" do
    task = logged_in_user.tasks.find_by_id "#{params[:task_id]}"
    logged_in_user.tasks.find(task.id).destroy
    session[:message]  = "Task has been cultivated successfully."
    redirect user_page
end