$(function () {
  $('.click-video').click(function () {
    url = new URL(window.location.href);
    var video_id = $(this).attr('class').split(' ').pop().split('-')[3];
    console.log($(this).attr('class'));
    ref_url = window.location.origin + '/medias/' + video_id;

    window.location.replace(ref_url);
      //debugger;
  });
})
