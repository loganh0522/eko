$(function(){ 
  $(".job-applicants form_tag > input").on("click", function(e){
    e.preventDefault();
    var $button = $(this);

    $button.siblings(".modal").css({
      top: $(window).scrollTop() + 100
    })

    $button.nextAll(".modal, .modal-layer").fadeIn(100);
  });

  $(".modal-layer").on("click", function(e){
    e.preventDefault(); 
    $(".modal-layer, .modal").filter(":visible").fadeOut(100)
  });
});