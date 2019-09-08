$( document ).on('turbolinks:load', function() {
  $(".nav-menu-button").hover(function() {
    $(".custom-list-categories").css("display", "block");
  }, function() {
    $(".custom-list-categories").css("display", "none");
  });

  $(".custom-list-categories").hover(function() {
    $(".custom-list-categories").css("display", "block");
  }, function() {
    $(".custom-list-categories").css("display", "none");
  });
})
