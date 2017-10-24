jQuery ->
  $('.owl-carousel').owlCarousel
    responsiveClass: true
    loop: false
    margin: 10
    nav: true
    dots: true
    responsive:
      0: 
        items: 1
        nav: true
      600: 
        items: 3
        nav: true
      1000: 
        items: 3
        nav: true
