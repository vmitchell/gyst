function ViewCircle() {
  this.hideMessageBoxes();
}

ViewCircle.prototype.hideMessageBoxes = function() {
  var successBox = $('.alert.alert-success');
  failBox = $('.alert.alert-danger');
  if (successBox.val() == "") {
    successBox.hide();
  }
  if (failBox.val() ==  "") {
    failBox.hide();
  }
};

ViewCircle.prototype.showCirlceCreateSuccess = function() {
  var $messageBox = $('.alert.alert-success');
  $messageBox.fadeIn();
  $messageBox.text("Circle has been created successfully")
};

ViewCircle.prototype.showCirlceCreateFail = function() {
  var $messageBox = $('.alert.alert-danger');
  $messageBox.fadeIn();
  $messageBox.text("There was an error, please try again")
};

ViewCircle.prototype.cleanInput = function() {
  this.getCreateCircleInput().val("");
};

 ViewCircle.prototype.getCreateCircleInput = function() {
  return $('.user-circles input#name');
};

ViewCircle.prototype.drawNewCircle = function(circle) {
  var newCircleEntry   = document.createElement('li');
        newCircleLink = document.createElement('a');
        newCIrcleSpan = document.createElement('span');
  newCircleLink.href = "/circle/"+circle[0].id;
  newCircleLink.innerHTML = circle[0].name;
  newCIrcleSpan.innerHTML = circle[1].count;
  newCircleEntry.className = 'circle';
  newCircleLink.appendChild(newCIrcleSpan);
    newCircleEntry.(newCircleLink);
  $('.user-circles ul li:last-child').append(newCircleEntry);
};

function Guide(view) {
  this.view = view;
  this.bindEvents();
}

Guide.prototype.bindEvents = function() {
  $(this.view.getCreateCircleInput).submit(this.createCircle.bind(this));
};

Guide.prototype.createCircle = function(e) {
  e.preventDefault();
  var name = this.view.getCreateCircleInput().val();
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