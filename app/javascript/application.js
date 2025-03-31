// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

import "./src/add_jquery";
import "./src/add_datatables";
import "chartkick/chart.js"

window.bootstrap = bootstrap;

document.addEventListener('turbo:load', function() {
  // Navbar Toggler
  const toggler = document.querySelector(".navbar-toggler");
  const sidebarToggler = document.querySelector(".sidebar-toggle");
  const sidebar = document.querySelector(".main-sidebar");
  const wrapper = document.querySelector("#wrapper");

  const breakpoint = 768; // Match CSS breakpoint

  // Load sidebar state from localStorage
  const isSidebarOpen = localStorage.getItem("sidebarOpen") === "true";
  const isDesktop = window.innerWidth >= breakpoint;

  // Function to update sidebar state based on window width
  function updateSidebarState() {
    const isDesktop = window.innerWidth >= breakpoint;
    // console.log(`Window width: ${window.innerWidth}, isDesktop: ${isDesktop}, sidebarOpen: ${wrapper.classList.contains("sidebar-open")}`);
    if (isDesktop) {
      wrapper.classList.add("sidebar-open");
      localStorage.setItem("sidebarOpen", "true");
    } else {
      wrapper.classList.remove("sidebar-open");
      localStorage.setItem("sidebarOpen", "false");
    }
  }

  // Set initial state
  updateSidebarState();

  // Debounce function to limit resize event frequency
  function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }

  // Add resize event listener with debounce
  window.addEventListener('resize', debounce(updateSidebarState, 200));

  // Toggle sidebar on mobile (navbar-toggler)
  if (toggler) {
    toggler.addEventListener("click", (event) => {
      event.preventDefault();
      wrapper.classList.toggle("sidebar-open");
      localStorage.setItem("sidebarOpen", wrapper.classList.contains("sidebar-open"));
    });
  }

  if (sidebarToggler) {
    sidebarToggler.addEventListener("click", (event) => {
      // console.log("Toggle sidebar");
      event.preventDefault();
      wrapper.classList.toggle("sidebar-open");
      localStorage.setItem("sidebarOpen", wrapper.classList.contains("sidebar-open"));
      const icon = sidebarToggler.querySelector("i");
      if (wrapper.classList.contains("sidebar-open")) {
        icon.classList.replace("bi-square", "bi-square-fill");
      } else {
        icon.classList.replace("bi-square-fill", "bi-square");
      }
    });
  }

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

