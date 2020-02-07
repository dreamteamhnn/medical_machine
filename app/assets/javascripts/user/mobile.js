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

    $('.td-certificates').remove();
    $('.td-media-video').remove();
    $('.td-experience-chosen').remove();
  } else {
    $('.list-categories-content-mobile').addClass('hidden');
    $('.td-certificates-mobile').remove();
    $('.td-media-video-mobile').remove();
    $('.td-experience-chosen-mobile').remove();
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
