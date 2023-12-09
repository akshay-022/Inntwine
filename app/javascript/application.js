// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "trix"
import "@rails/actiontext"


document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.arrow-icon').forEach(function(arrow) {
      arrow.addEventListener('click', function(event) {
        event.stopPropagation();
        const subItems = this.parentElement.querySelector('.sub-items');
        subItems.classList.toggle('hidden');
      });
    });
  
    document.querySelectorAll('.sidebar-item').forEach(function(item) {
      item.addEventListener('click', function() {
        // Reload the page when any heading is clicked
        window.location.reload();
      });
    });
  });