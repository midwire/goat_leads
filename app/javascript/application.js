import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

import "./src/add_jquery";
import "./src/add_datatables";
import "chartkick/chart.js";

document.addEventListener('turbo:load', () => {

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
});

// Turbo cache fix for DataTables
document.addEventListener("turbo:before-cache", () => {
  const dataTable = $?.fn?.dataTable?.tables(true);
  if (dataTable?.length) {
    $(dataTable).DataTable().destroy();
  }
});

window.bootstrap = bootstrap;

