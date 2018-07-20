$(document).on('turbolinks:load', function(){
  $('#create-template-btn').on('click', function(e) {
    e.preventDefault();
    $('#template-modal #name_template').val('');
    $('#template-modal').data('id', '');
    CKEDITOR.instances.template_content.setData('[blog_content]');
    $('#template-modal').modal('show');
  });

  $('.template').find('.edit-btn').on('click', function(e) {
    var templateContent = $(this).prev().html();
    var templateName = $(this).siblings('h3').text();
    var templateId = $(this).data('id');
    CKEDITOR.instances.template_content.setData(templateContent);
    $('#template-modal #name_template').val(templateName);
    $('#template-modal').data('id', templateId);
    $('#template-modal').modal('show');
  });

  $('#save-template-btn').on('click', function() {
    var templateId = $('#template-modal').data('id');
    var templateName = $('#name_template').val();
    var templateContent = CKEDITOR.instances.template_content.getData();
    if(templateId.toString().length) {
      $.ajax({
        url: '/admin/templates/' + templateId,
        method: 'put',
        data: {template: {name: templateName, content: templateContent}},
        success: function(result, status, xhr) {
          if(result.status === 'success') {
            $('#template-modal').modal('hide');
            $('#message-content').text('Sửa template thành công');
            $('#message-modal').modal('show');
            window.location.href = '/admin/templates';
          }
        },
        error: function() {
        }
      });
    } else {
      $.ajax({
        url: '/admin/templates/',
        method: 'post',
        data: {template: {name: templateName, content: templateContent}},
        success: function(result, status, xhr) {
          if(result.status === 'success') {
            $('#template-modal').modal('hide');
            $('#message-content').text('Tạo template thành công');
            $('#message-modal').modal('show');
            window.location.href = '/admin/templates';
          }
        },
        error: function() {
        }
      });
    }
  });


  $('.template').find('.delete-btn').on('click', function(e) {
    var templateId = $(this).data('id');
    $('#delete-template').data('id', templateId);
    $('#delete-template').modal('show');
  });

  $('#button-delete-template').on('click', function() {
    var templateId = $('#delete-template').data('id');
    $.ajax({
      url: '/admin/templates/' + templateId,
      method: 'delete',
      success: function(result, status, xhr) {
        if(result.status === 'success') {
          $('#delete-template').modal('hide');
          $('#message-content').text('Xóa template thành công');
          $('#message-modal').modal('show');
          window.location.href = '/admin/templates';
        }
      },
      error: function() {
      }
    });
  });
});
