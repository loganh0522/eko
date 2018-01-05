jQuery ->
  modal = document.getElementById('mediumModal')

  $(".close-modal").on 'click', (event) -> 
    $('.newModal').hide()
    
  window.onclick = (event) ->
    if event.target == modal
      modal.style.display = 'none'
    return

  $(document).ajaxComplete ->  
    $(".close-modal").on 'click', (event) -> 
      $('.newModal').hide()
