$(document).on('turbolinks:load', function(){
  jssor_brand_slider_init = function() {
    var jssor_1_options = {
      $AutoPlay: 1,
      $Idle: 0,
      $SlideDuration: 5000,
      $SlideEasing: $Jease$.$Linear,
      $PauseOnHover: 4,
      $SlideWidth: 100,
      $SlideHeight: 50,
      $SlideSpacing: 10,
      $Cols: 20,
      $Align: 0
    };

    var jssor_1_slider = new $JssorSlider$("jssor_brand", jssor_1_options);

    /*#region responsive code begin*/

    var MAX_WIDTH = 1800;

    function ScaleSlider() {
        var containerElement = jssor_1_slider.$Elmt.parentNode;
        var containerWidth = containerElement.clientWidth;

        if (containerWidth) {

            var expectedWidth = Math.min(MAX_WIDTH || containerWidth, containerWidth);

            jssor_1_slider.$ScaleWidth(expectedWidth);
        }
        else {
            window.setTimeout(ScaleSlider, 30);
        }
    }

    ScaleSlider();

    $Jssor$.$AddEvent(window, "load", ScaleSlider);
    $Jssor$.$AddEvent(window, "resize", ScaleSlider);
    $Jssor$.$AddEvent(window, "orientationchange", ScaleSlider);
    /*#endregion responsive code end*/
  };

  jssor_brand_slider_init();

});
