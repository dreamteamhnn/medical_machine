$( document ).on('turbolinks:load', function() {
  if ($(document).width() <= 768) {
    $('.nav-menu-button').on('click', function() {
      $('.list-categories-content-mobile').removeClass('hidden')
    })

    $('.close-list-categories-mobile').on('click', function() {
      $('.list-categories-content-mobile').addClass('hidden')
    })
  } else {
    $('.list-categories-content-mobile').addClass('hidden')
  }
})
