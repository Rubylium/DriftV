$(function () {
  window.addEventListener("message", function (event) {
    var item = event.data;

  });

  $('.clickJoinButton').on('click', function (e) {
		e.preventDefault();
		$.post('https://driftv/joinServer', JSON.stringify(test = false));
	});
});