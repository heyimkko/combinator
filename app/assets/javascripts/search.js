$(document).ready(function() {
  $("body").on("click", "#search-button", function() {
    callFlyShortcut($(this))
  });

  var callFlyShortcut = function(ele)  {
    var url = ele.attr("data-flight-results-url");
    $.ajax({
      url: url
    })
    .done(function(data) {
      $(".results").after(data.results);
    });
  }
});