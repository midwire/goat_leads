import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

import "./src/add_jquery";
import "./src/add_datatables";
import "chartkick/chart.js";

// Get the whitelabel from the stylesheet link
function getWhitelabel() {
  const link = document.querySelector('link[rel="stylesheet"][data-turbo-track="reload"]');
  if (link && link.href) {
    const match = link.href.match(/\/assets\/(.+?)-[a-f0-9]+\.css/); // Extract base name before fingerprint
    return match[1] // ? match[1] : 'goatleads'; // Fallback to 'goatleads'
  }
  return 'goatleads';
}

function isStylesheetLoaded() {
  const whitelabel = getWhitelabel();
  const stylesheets = Array.from(document.styleSheets);
  const loaded = stylesheets.some(sheet => sheet.href && sheet.href.includes(whitelabel));
  // console.log(`Stylesheet loaded: (${whitelabel})`, loaded);
  return loaded;
}

// Check if JS is loaded (e.g., jQuery, DataTables, Chartkick if used)
function areScriptsLoaded() {
  return true;
  // Adjust based on your lazy-loaded libraries
  // return (!document.querySelector('.needs-jquery') || window.jQuery) &&
  //        (!document.querySelector('.needs-datatables') || $.fn.DataTable) &&
  //        (!document.querySelector('.needs-chartkick') || window.Chartkick);
}

// Hide loading overlay and show content
function hideLoadingOverlay() {
  const overlay = document.getElementById('loading-overlay');
  const wrapper = document.getElementById('wrapper');
  // console.log('Hiding overlay:', overlay, wrapper);
  if (overlay && wrapper) {
    overlay.classList.add('hidden');
    wrapper.classList.add('loaded');
  }
}

function initializeApp() {
  // console.log("Initializing app...");

  // Navbar and Sidebar Toggling
  const toggler = document.querySelector(".navbar-toggler");
  const sidebarToggler = document.querySelector(".sidebar-toggle");
  const wrapper = document.querySelector("#wrapper");
  const breakpoint = 768;

  // Load sidebar state
  const isSidebarOpen = localStorage.getItem("sidebarOpen") === "true";
  const isDesktop = window.innerWidth >= breakpoint;

  function updateSidebarState() {
    if (window.innerWidth >= breakpoint) {
      wrapper.classList.add("sidebar-open");
      localStorage.setItem("sidebarOpen", "true");
    } else {
      wrapper.classList.remove("sidebar-open");
      localStorage.setItem("sidebarOpen", "false");
    }
  }

  // Initial state
  updateSidebarState();

  // Debounced resize handler
  const debounce = (func, wait) => {
    let timeout;
    return (...args) => {
      clearTimeout(timeout);
      timeout = setTimeout(() => func(...args), wait);
    };
  };
  window.addEventListener('resize', debounce(updateSidebarState, 200));

  // Toggler events
  toggler?.addEventListener("click", (e) => {
    e.preventDefault();
    wrapper.classList.toggle("sidebar-open");
    localStorage.setItem("sidebarOpen", wrapper.classList.contains("sidebar-open"));
  });

  sidebarToggler?.addEventListener("click", (e) => {
    e.preventDefault();
    wrapper.classList.toggle("sidebar-open");
    localStorage.setItem("sidebarOpen", wrapper.classList.contains("sidebar-open"));
    const icon = sidebarToggler.querySelector("i");
    icon.classList.toggle("bi-square-fill", wrapper.classList.contains("sidebar-open"));
    icon.classList.toggle("bi-square", !wrapper.classList.contains("sidebar-open"));
  });

  // Show toasts
  document.querySelectorAll('.toast').forEach(toast => new bootstrap.Toast(toast).show());

  // Check assets and hide overlay
  if (isStylesheetLoaded() && areScriptsLoaded()) {
    hideLoadingOverlay();
  } else {
    // console.log("Still Loading...");
    const whitelabel = getWhitelabel();
    const link = document.querySelector(`link[href*="${whitelabel}"]`);
    if (link) {
      link.addEventListener('load', hideLoadingOverlay);
    } else {
      console.warn('Stylesheet link not found, using timeout fallback');
      setTimeout(hideLoadingOverlay, 1000); // Fallback
    }
  }

}

document.addEventListener('turbo:load', () => {
  initializeApp();
  if (isStylesheetLoaded() && areScriptsLoaded()) {
    hideLoadingOverlay();
  }
});

document.addEventListener('turbo:before-render', () => {
  const overlay = document.getElementById('loading-overlay');
  if (overlay && overlay.classList.contains('hidden')) {
    overlay.dataset.hidden = 'true';
  }
});

document.addEventListener('turbo:render', () => {
  const overlay = document.getElementById('loading-overlay');
  if (overlay && overlay.dataset.hidden === 'true') {
    overlay.classList.add('hidden');
  }
});


// Turbo cache fix for DataTables
document.addEventListener("turbo:before-cache", () => {
  const dataTable = $?.fn?.dataTable?.tables(true);
  if (dataTable?.length) {
    $(dataTable).DataTable().destroy();
  }
});

window.bootstrap = bootstrap;

// document.addEventListener('turbo:load', runOnLoad);
