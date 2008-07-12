$(document).ready( function() {
  $('a.delete').click( function() {
    if ( confirm("Are you sure?") ) {
      var href = $(this).attr('href');
      $.ajax({ type: 'delete', url: href,
        success: function() { window.location = '/entries'; }
      });
    }
    // this isn't really a link ...
    // so tell the browser we've handled it
    return false;
  });
});
