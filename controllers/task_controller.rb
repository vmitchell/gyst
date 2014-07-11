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
      session[:message] = "Creation of the task was successfull, my lord."
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
    alert = Alert.find_by_task_id @task.id
    if @task.save
        alert.nil? ? "" : alert.destroy
        session[:message] = 'Your task was successfully edited.'
        redirect user_page
    else
        @errors = @task.errors.full_messages
        haml :edit_task
    end
end

get "/task/:task_id/delete" do
    task = logged_in_user.tasks.find_by_id "#{params[:task_id]}"
    logged_in_user.tasks.find(task.id).destroy
    session[:message]  = "Task has been cultivated successfully."
    alert = Alert.find_by_task_id task.id
    alert.nil? ? "" : alert.destroy
    redirect user_page
end

get '/remind/:user_id/:task_id' do
    task = Task.find_by_id params[:task_id]
    user = User.find_by_id params[:user_id]
    match = logged_in_user.alerts.find_by_task_id task.id
    if !match.nil?
        show_message "You have already reminded #{user.name} about this task."
        redirect user_page
    else
        create_reminder
        show_message "Successfully reminded #{user.name} about his task to #{task.name}"
        send_email user.email,
                           "#{logged_in_user.name} reminds you about your task to #{task.name}. PLEASE DO IT",
                           "Reminder from #{logged_in_user.name}"
        redirect user_page
    end
end


