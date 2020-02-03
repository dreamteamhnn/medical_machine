$(document).on('turbolinks:load', function(){
  function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }

  function removeParam(key, sourceURL) {
    var rtn = sourceURL.split("?")[0],
      param,
      params_arr = [],
      queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
    if (queryString !== "") {
      params_arr = queryString.split("&");
      for (var i = params_arr.length - 1; i >= 0; i -= 1) {
          param = params_arr[i].split("=")[0];
          if (param === key) {
              params_arr.splice(i, 1);
          }
      }
      rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
  }

  $(".woocommerce-orderby").on("change", function() {
    var sym = location.href.indexOf("?") != -1 ? "&" : "?";
    var sortParam = $(this).val() == "default" ? "" : (sym + "sort_by=" + $(this).val());
    var url = removeParam("sort_by", location.href) + sortParam;
    location.href = url;
  });

  $("#archives-dropdown-4").on("change", function() {
    location.href = $(this).val();
  });

  $(".select-category").on("click", function() {
    var categoryId = $(this).attr("name").replace("category-", "");
    var url = removeParam("category_id", location.href);
    var id = parseInt(url.substring(url.lastIndexOf('/') + 1)) || 0;
    var slug = $(this).attr('data-slug');
    if (id > 0) {
      url = url.replace("/" + id, "");
    }
    if (getParameterByName("brand_id", url)) {
      url = removeParam("brand_id", url);
    }
    var sym = url.indexOf("?") != -1 ? "&" : "?";
    url += sym + "category_id=" + categoryId;
    var path = location.href.split('/')[0]
    location.href = path + '/loai-san-pham/' + slug;
  });

  function sortByPrice() {
    var sym = location.href.indexOf("?") != -1 ? "&" : "?";
    var url = removeParam("min_price", removeParam("max_price", location.href));
    var minPriceParam = $("#min_price").val() ? (sym + "min_price=" + $("#min_price").val()) : "";
    var maxPriceParam = $("#max_price").val() ? (sym + "max_price=" + $("#max_price").val()) : "";
    location.href  = url + minPriceParam + maxPriceParam;
  }

  $("#min_price").val(getParameterByName("min_price"));
  $("#max_price").val(getParameterByName("max_price"));

  $('#min_price, #max_price').focusout(function() {
    sortByPrice();
  });

  $("#min_price, #max_price").on('keyup', function (e) {
    if (e.keyCode == 13) {
      sortByPrice();
    }
  });

  $("#min_price, #max_price").keydown(function (e) {
    // Allow: backspace, delete, tab, escape, enter and .
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
         // Allow: Ctrl/cmd+A
        (e.keyCode == 65 && (e.ctrlKey === true || e.metaKey === true)) ||
         // Allow: Ctrl/cmd+C
        (e.keyCode == 67 && (e.ctrlKey === true || e.metaKey === true)) ||
         // Allow: Ctrl/cmd+X
        (e.keyCode == 88 && (e.ctrlKey === true || e.metaKey === true)) ||
         // Allow: home, end, left, right
        (e.keyCode >= 35 && e.keyCode <= 39)) {
             // let it happen, don't do anything
             return;
    }
    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
        e.preventDefault();
    }
  });

  // Show modal video
  $(".iframe-video-image").on("click", function() {
    var id = $(this).data("video");
    $("#modal-video-" + id).modal("show");
  })

  $(".modal").on('hide.bs.modal', function () {
    $(this).find(".iframe-modal").attr('src', $(this).find(".iframe-modal").attr('src'));
  });

  $(".certificate-img").on("click", function() {
    var id = $(this).data("cert");
    $("#modal-video-" + id).modal("show");
  })
});
