$( document ).on('turbolinks:load', function() {
  if ($(document).width() <= 768) {
    $('.nav-menu-button').on('click', function() {
      $('.list-categories-content-mobile').removeClass('hidden')
    })

    $('.close-list-categories-mobile').on('click', function() {
      $('.list-categories-content-mobile').addClass('hidden')
    })

    $('.blog-list-link').on('click', function(e) {
      e.preventDefault();
    })
  } else {
    $('.list-categories-content-mobile').addClass('hidden')
  }

  $(window).on('resize', function() {
    if ($(document).width() <= 768) {
      $('.nav-menu-button').on('click', function() {
        $('.list-categories-content-mobile').removeClass('hidden')
      })

      $('.close-list-categories-mobile').on('click', function() {
        $('.list-categories-content-mobile').addClass('hidden')
      })

      $('.blog-list-link').on('click', function(e) {
        e.preventDefault();
      })
    } else {
      $('.list-categories-content-mobile').addClass('hidden')
    }
  })
})
