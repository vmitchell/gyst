function ViewCircle() {
  this.hideMessageBoxes();
}

ViewCircle.prototype.hideMessageBoxes = function() {
  var successBox = $('.alert.alert-success');
  failBox = $('.alert.alert-danger');
  if (successBox.val() == "" && successBox.text() != "" ) {
    successBox.hide();
  }
  if (failBox.val()  ==  "" && failBox.text() != "") {
    failBox.hide();
  }
};

ViewCircle.prototype.showCirlceCreateSuccess = function() {
  var $messageBox = $('.alert.alert-success');
  $messageBox.fadeIn('slow');
  $messageBox.text("Circle has been created successfully")
};

ViewCircle.prototype.showCirlceCreateFail = function() {
  var $messageBox = $('.alert.alert-danger');
  $messageBox.fadeIn('slow');
  $messageBox.text("There was an error, please try again")
};

ViewCircle.prototype.cleanInput = function() {
  this.getCircleCreateInput().val("");
};

 ViewCircle.prototype.getCircleCreateInput = function() {
  return $('.user-create-circle input#name');
};

 ViewCircle.prototype.getCircleCreateForm = function() {
  return $('.user-create-circle #circle-create-form');
};

ViewCircle.prototype.drawNewCircle = function(circle) {
  var newCircleEntry   = document.createElement('li');
        newCircleLink = document.createElement('a');
        // newCircleSpan = document.createElement('span');
        newCircleEdit = document.createElement('a');
        newCircleDelete = document.createElement('a');
  newCircleLink.href = "/circle/"+circle[0].id;
  newCircleLink.innerHTML = circle[0].name;
  newCircleEdit.href = "/circle/"+circle[0].id+"/edit";
  newCircleEdit.innerHTML = " edit "
  newCircleDelete.href="/circle/"+circle[0].id+"/delete";
  newCircleDelete.innerHTML = " delete (no confirm) "
  // newCircleSpan.innerHTML = "- "+circle[1].count;
  newCircleEntry.className = 'circle';
  newCircleEntry.appendChild(newCircleLink);
  // newCircleEntry.appendChild(newCircleSpan);
  newCircleEntry.appendChild(newCircleEdit)
  newCircleEntry.appendChild(newCircleDelete)
  $('.user-circles ul li').append(newCircleEntry);
};

function Guide(view) {
  this.view = view;
  this.bindEvents();
}

Guide.prototype.bindEvents = function() {
  $(this.view.getCircleCreateForm()).submit(this.createCircle.bind(this));
};

Guide.prototype.createCircle = function(e) {
  e.preventDefault();
  e.stopPropagation();
  var name = this.view.getCircleCreateInput().val();
  self = this;
  $.ajax({
    type: "post",
    url: "/circles/new",
    data: { name: name }
  })
  .done(function(response) {
    self.view.drawNewCircle(response);
    self.view.showCirlceCreateSuccess();
    self.view.cleanInput();
  })
  .fail(function(response) {
    self.view.showCirlceCreateFail();
  });
}