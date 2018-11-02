// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(document).ready(function() {

  // Use auto-complete; fetch customer name from DB via 'search' method
  $( "#cust_name" ).autocomplete({
    source: '/search',
    minLength: 2,
    select: function (event, ui) {
        $(event.target).val(ui.item.value);
        $('#search').submit();
        return false;
    }
  });

});
