get '/circle/invite/accept/:alert_id' do 
    alert = logged_in_user.alerts.find_by_id params[:alert_id]
    if !alert.nil? && is_logged_in?
        creator = User.find_by_id(alert.creator_id)
        circle_id = alert.add_to_circle_id
        circle = Circle.find_by_id circle_id
             logged_in_user.circles << circle
        if logged_in_user.circles.find circle
            show_message "You can now see #{creator.name}'s tasks in your newsfeed"
            alert.destroy
            redirect user_page
        end
    else
        show_message "Sorry, wrong alert number"
        redirect user_page
    end
end

get '/circle/invite/decline/:alert_id' do
    alert = logged_in_user.alerts.find_by_id params[:alert_id]
    if !alert.nil?
        alert.destroy
        show_message "Invitation has been declined."
        redirect user_page
    else
        show_message "Sorry, wrong alert number"
        redirect user_page
    end
end