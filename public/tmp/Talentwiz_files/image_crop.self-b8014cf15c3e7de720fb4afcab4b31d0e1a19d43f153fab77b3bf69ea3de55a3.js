(function() {
  var AvatarCropper,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  jQuery(function() {
    return $(document).ajaxComplete(function() {
      return $('#cropbox').on('load', function(event) {
        return new AvatarCropper;
      });
    });
  });

  AvatarCropper = (function() {
    function AvatarCropper() {
      this.updatePreview = bind(this.updatePreview, this);
      this.update = bind(this.update, this);
      $('#cropbox').Jcrop({
        aspectRatio: 1,
        setSelect: [0, 0, 150, 150],
        boxWidth: 300,
        boxHeight: 300,
        bgOpacity: 1,
        onSelect: this.update,
        onChange: this.update
      });
    }

    AvatarCropper.prototype.update = function(coords) {
      $('#user_avatar_crop_x').val(coords.x);
      $('#user_avatar_crop_y').val(coords.y);
      $('#user_avatar_crop_w').val(coords.w);
      $('#user_avatar_crop_h').val(coords.h);
      return this.updatePreview(coords);
    };

    AvatarCropper.prototype.updatePreview = function(coords) {
      $('#preview').css({
        width: Math.round(150 / coords.w * $('#cropbox').width()) + 'px',
        height: Math.round(150 / coords.h * $('#cropbox').height()) + 'px',
        marginLeft: '-' + Math.round(150 / coords.w * coords.x) + 'px',
        marginTop: '-' + Math.round(150 / coords.h * coords.y) + 'px'
      });
      $('#preview-2').css({
        width: Math.round(60 / coords.w * $('#cropbox').width()) + 'px',
        height: Math.round(60 / coords.h * $('#cropbox').height()) + 'px',
        marginLeft: '-' + Math.round(60 / coords.w * coords.x) + 'px',
        marginTop: '-' + Math.round(60 / coords.h * coords.y) + 'px'
      });
      $('#preview-3').css({
        width: Math.round(50 / coords.w * $('#cropbox').width()) + 'px',
        height: Math.round(50 / coords.h * $('#cropbox').height()) + 'px',
        marginLeft: '-' + Math.round(50 / coords.w * coords.x) + 'px',
        marginTop: '-' + Math.round(50 / coords.h * coords.y) + 'px'
      });
      return $('#preview-4').css({
        width: Math.round(40 / coords.w * $('#cropbox').width()) + 'px',
        height: Math.round(40 / coords.h * $('#cropbox').height()) + 'px',
        marginLeft: '-' + Math.round(40 / coords.w * coords.x) + 'px',
        marginTop: '-' + Math.round(40 / coords.h * coords.y) + 'px'
      });
    };

    return AvatarCropper;

  })();

}).call(this);
