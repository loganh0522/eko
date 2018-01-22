//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}
//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}
//Display the confirmation dialog

$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  $('.destroyModal').show();
  $('.destroyModal').find('.modal-footer').html('')
  $('.destroyModal').find('.new-title').html('Destroy')
  $('.destroyModal').find('.modal-body').html('<div class="content"><h3> Are you sure? You can not undo this action. </h3></div>')
  $('.modal-footer').append('<a class="btn danger-btn confirm">Destroy</a>')
  $('.modal-footer').append('<div class="btn border-button close-modal"> Cancel </div>')

  $(".close-modal").on('click', function(event) {
    return $('.newModal').hide();
  });

  $('.confirm').on('click', function(event) {
    $.rails.confirmed(link);
    return $('.newModal').hide();
  });
}


