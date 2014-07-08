require_relative '../models/task'


Task.create(name: 'My beautiful task', :location => 'Bedroom', :due => "")

User.create( name: "Admin", :email => "ibeatnorris@gmail.com", :username => "admin", :password => "admin", id: 1 )
