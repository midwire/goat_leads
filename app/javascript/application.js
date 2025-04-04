import "@hotwired/turbo-rails";
import "./controllers";
import * as bootstrap from "bootstrap";

// Function to load libraries dynamically
function loadLibraries() {
  if (document.querySelector('.needs-jquery') && !window.jQuery) {
    import("./src/add_jquery")
      .then(() => console.log("jQuery loaded"))
      .catch(err => console.error("Failed to load jQuery:", err));
  }
  if (document.querySelector('.needs-datatables') && !$.fn.DataTable) {
    import("./src/add_datatables")
      .then(() => console.log("DataTables loaded"))
      .catch(err => console.error("Failed to load DataTables:", err));
  }
  if (document.querySelector('.needs-chartkick') && !window.Chartkick) {
    import("chartkick/chart.js")
      .then(() => console.log("Chartkick loaded"))
      .catch(err => console.error("Failed to load Chartkick:", err));
  }
}

// Lazy-load heavy libraries only when needed
document.addEventListener('turbo:load', () => {
  // Lazy load required libraries
  loadLibraries();

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

