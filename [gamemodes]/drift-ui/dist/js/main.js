"use strict";

document.querySelector('.burger').addEventListener('click', function () {
  document.querySelector('.burger').classList.toggle('open');
  document.querySelector('nav ul').classList.toggle('open');
});