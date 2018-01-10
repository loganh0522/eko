jQuery ->
  $('.photos-carousel').slick(
    slidesToShow: 3,
    infinte: true,
    slidesToScroll: 1
    )

  $(document).ajaxComplete ->
    $('.slick-carousel').slick(
      dots: true

      )
    $('.photos-carousel').slick(
      slidesToShow: 3,
      infinte: true,
      slidesToScroll: 1
      )
