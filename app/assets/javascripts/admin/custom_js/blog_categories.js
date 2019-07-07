$(document).on('turbolinks:load', function(){
  $('.blog-cate-delete-btn').on('click', function() {
    var deleteCateUrl = '/admin/blog_categories/' + $(this).attr('data-blog-cate-id');
    $('#button-delete-blog-cate-confirm').attr('href', deleteCateUrl);
    $('#delete-blog-category-modal').modal('show');
  });
});
