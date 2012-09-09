$(function () {
    $("#feed_options li a, .opt_link_info a").live("click", function () {
      /* alert("click event triggered");  */
      //$.get(this.href, null, null, "script");
      $.getScript(this.href);
      // alert("After getScript triggered");
      return false;
    });

//     $("#edit_name").live("click", function () {
//       
//       
//     });
//   
    
});