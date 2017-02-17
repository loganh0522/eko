jQuery ->
  $(document).ajaxComplete -> 
    new AvatarCropper

  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader

      reader.onload = (e) ->
        $('.blah').attr 'src', e.target.result
        return

      reader.readAsDataURL input.files[0]
    return

  $('#imgInp').change ->
    readURL this
    new AvatarCropper
    $('.blah').show()
    $('#submit-crop').show()
    $('.close-form').show()
    $('.img-preview-blank').hide()
    $('.img-preview-blank-2').hide()
    $('.img-preview-blank-3').hide()
    $('.img-preview-blank-4').hide()
    $('.img-preview').show()
    $('.img-preview-2').show()
    $('.img-preview-3').show()
    $('.img-preview-4').show()
    return

class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 150, 150]
      boxWidth: 300
      boxHeight: 300
      bgOpacity: 1
      onSelect: @update
      onChange: @update
  
  update: (coords) =>
    $('#user_avatar_crop_x').val(coords.x)
    $('#user_avatar_crop_y').val(coords.y)
    $('#user_avatar_crop_w').val(coords.w)
    $('#user_avatar_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(150/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(150/coords.h * $('#cropbox').height()) + 'px'

      marginLeft: '-' + Math.round(150/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(150/coords.h * coords.y) + 'px'

    $('#preview-2').css
      width: Math.round(60/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(60/coords.h * $('#cropbox').height()) + 'px'

      marginLeft: '-' + Math.round(60/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(60/coords.h * coords.y) + 'px'

    $('#preview-3').css
      width: Math.round(50/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(50/coords.h * $('#cropbox').height()) + 'px'

      marginLeft: '-' + Math.round(50/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(50/coords.h * coords.y) + 'px'

    $('#preview-4').css
      width: Math.round(40/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(40/coords.h * $('#cropbox').height()) + 'px'

      marginLeft: '-' + Math.round(40/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(40/coords.h * coords.y) + 'px'




