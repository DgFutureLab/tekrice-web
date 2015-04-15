var rice_pic = $("#rice_pic");
if (window.data["dist"] > 55.0) {
  rice_pic.attr("src", "/images/sadrice.jpg")
} else {
  rice_pic.attr("src", "/images/happyrice.jpg")
}
