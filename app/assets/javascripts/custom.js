/* global $*/
$(document).ready(function() {
  var maxCardHeight = 0;
  $('.card').each(function() {
    if ($(this).height() > maxCardHeight) {
      maxCardHeight = $(this).height();
    }
  });
  $('.card').height(maxCardHeight);
});