$(document).ready(function() {
  fetch_price();
  add_service();
  extra_rows = 0;  

  // Fetch customer via autocomplete; passes input box text 'search' method
  $( "#cust_name_form" ).autocomplete({
    source: '/search',
    minLength: 2,
    select: function (event, ui) {
        $(event.target).val(ui.item.value);
        $('#treatment_customer_id').find('option:contains(' + ui.item.value + ')').attr("selected",true);
        return false;
    }
  });

  // Income plots hidden or shown
  $("#toggle_plots").click(function() { 
    $tp = $("#toggle_plots");
    if ($tp.text() == 'Show Graphs') {
      $tp.text('Hide Graphs');
    } else {
      $tp.text('Show Graphs');
    }
    $("#plots").toggle('slow');
  });

});

// auto-fill price from selected service
function fetch_price() {
  var $ts = $('ul.services li select');

  $ts.change(function(e) {
    $.getJSON("/services/" + e.target.value, function(data) {
      $(e.target).next('input').val(data.price).focus().select();
    });
  });
}

// add a service row when clicked
function add_service() {
  $('#add_service').click(function() {  
    extra_rows++;
    var opts = $("[id^=treatment_acts]").html();
    var row =
      '<hr/><li>' 
      + '<select id="treatment_acts_attributes_x'
          + extra_rows +
        '_service_id" name="treatment[acts_attributes][x'
          + extra_rows +
        '][service_id]">'
        + opts + 
        '</select>'
      + ' $ <input id="treatment_acts_attributes_x'
          + extra_rows +
        '_cost" type="text" value="0.0" size="5" name="treatment[acts_attributes][x'
          + extra_rows +
        '][cost]"></input></li>'
    ;

    $('#act_list').append(row);
    fetch_price();
  });
  
}
