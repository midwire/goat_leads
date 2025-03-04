// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./src/add_jquery";
// import './src/jquery-ui.min';
import "./src/add_datatables";

// window.bootstrap = require('bootstrap/dist/js/bootstrap.bundle.js')

document.addEventListener('turbo:load', function() {

  document.querySelectorAll('.toast').forEach((toast) => {
    return new bootstrap.Toast(toast).show();
  });

});
