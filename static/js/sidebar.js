$('.node_link').on("click", function(){
  var node = '#' + $(this).text();
  $(node).click();
});
