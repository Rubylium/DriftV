$(document).ready(function(){
  window.addEventListener('message', function(event) {
      var node = document.createElement('textarea');
      var selection = document.getSelection();

      node.textContent = event.data.coords;
      document.body.appendChild(node);

      selection.removeAllRanges();
      node.select();
      document.execCommand('copy');

      selection.removeAllRanges();
      document.body.removeChild(node);
  });
});
