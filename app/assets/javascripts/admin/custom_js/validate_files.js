function validateFiles(inputFile) {
  var maxExceededMessage = "Dung lượng tối đa của file là: (5 MB)";
  var extErrorMessage = "Vui lòng nhập các tài liệu có đuôi như sau: .doc, .docx, .xls, .xlsx, .pdf";
  var allowedExtension = ["doc", "docx", "xls", "xlsx", "pdf"];

  var extName;
  var maxFileSize = $(inputFile).data('max-file-size');
  var sizeExceeded = false;
  var extError = false;

  $.each(inputFile.files, function() {
    if (this.size && maxFileSize && this.size > parseInt(maxFileSize)) {sizeExceeded=true;};
    extName = this.name.split('.').pop();
    if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
  });
  if (sizeExceeded) {
    window.alert(maxExceededMessage);
    $(inputFile).val('');
  };

  if (extError) {
    window.alert(extErrorMessage);
    $(inputFile).val('');
  };
}
