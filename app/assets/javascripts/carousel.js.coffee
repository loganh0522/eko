jQuery ->
  $('.photos-carousel').slick(
    slidesToShow: 3,
    infinte: true,
    slidesToScroll: 1,
    prevArrow:"<button type='button' class='slick-prev pull-left'><i class='fa fa-angle-left' aria-hidden='true'></i></button>",
    nextArrow:"<button type='button' class='slick-next pull-right'><i class='fa fa-angle-right' aria-hidden='true'></i></button>",
    adaptiveHeight: false
    responsive: [{
      breakpoint: 1024
      settings:
        slidesToShow: 3
        slidesToScroll: 3
        infinite: true
      }
      {
        breakpoint: 600
        settings:
          slidesToShow: 2
          slidesToScroll: 2
      }
      {
        breakpoint: 480
        settings:
          slidesToShow: 1
          slidesToScroll: 1
      }
    ]
    )

  $(document).ajaxComplete ->
    $('.slick-carousel').slick(
      dots: true
      prevArrow:"<button type='button' class='slick-prev pull-left'><i class='fa fa-angle-left' aria-hidden='true'></i></button>",
      nextArrow:"<button type='button' class='slick-next pull-right'><i class='fa fa-angle-right' aria-hidden='true'></i></button>"

      )
    $('.photos-carousel').slick(
      slidesToShow: 3,
      infinte: true,
      cssEase: 'linear'
      slidesToScroll: 1
      )
