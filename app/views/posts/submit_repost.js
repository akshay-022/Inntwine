// app/assets/javascripts/submit_repost.js

document.addEventListener("turbo:load", function() {
  // Check for a flash notice
  var flashNotice = "<%= j flash[:notice] %>";

  if (flashNotice) {
    alert(flashNotice);
  }

  // Simulate a full page reload
  Turbolinks.visit(window.location.href, { action: 'replace' });
});