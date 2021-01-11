function betterNumber(x) {
  return x.toLocaleString("fr-FR");
}

$(function () {
  window.addEventListener("message", function (event) {
    var item = event.data;

    if (item.ShowHud) {
      // Drift points
      $(".driftDisplay").html(betterNumber(item.driftPoints));
      $(".driftDisplayMulti").html(item.driftDisplayMulti);

      $("#container").fadeIn(500);
    } else if (item.HideHud) {
      // Hide GUI
      $("#container").fadeOut(500);
    }
  });
});
