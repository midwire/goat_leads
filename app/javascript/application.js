// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./src/add_jquery";
import "./src/add_datatables";

// window.bootstrap = require('bootstrap/dist/js/bootstrap.bundle.js')
window.bootstrap = bootstrap;

document.addEventListener('turbo:load', function() {
  // Navbar Toggler
  const toggler = document.querySelector(".navbar-toggler");
  const sidebar = document.querySelector(".main-sidebar");
  const wrapper = document.querySelector("#wrapper");

  toggler.addEventListener("click", () => {
    wrapper.classList.toggle("sidebar-open");
  });

  document.querySelectorAll('.toast').forEach((toast) => {
    return new bootstrap.Toast(toast).show();
  });

});

// Fix datatable back-button reinitialization
document.addEventListener("turbo:before-cache", function() {
  var dataTable = $($.fn.dataTable.tables(true)).DataTable();
  if (dataTable !== null) {
    dataTable.destroy();
    dataTable = null;
  }
});

