/* Shared mobile navigation enhancement for Rare Disease Club.
   Adds a hamburger toggle that collapses the nav links on small screens.
   Progressive enhancement: without JS the menu stays fully visible. */
(function () {
  function initMobileNav() {
    document.querySelectorAll('nav').forEach(function (nav) {
      var links = nav.querySelector('.nav-links');
      if (!links || nav.classList.contains('js-nav')) return;
      nav.classList.add('js-nav');

      var toggle = document.createElement('button');
      toggle.type = 'button';
      toggle.className = 'nav-toggle';
      toggle.setAttribute('aria-label', 'Toggle navigation menu');
      toggle.setAttribute('aria-expanded', 'false');
      toggle.innerHTML = '<span></span><span></span><span></span>';

      links.parentNode.insertBefore(toggle, links);

      toggle.addEventListener('click', function () {
        var open = nav.classList.toggle('open');
        toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
      });

      // Close the menu after tapping a real link (but not the About toggle,
      // which only expands its sub-menu).
      links.querySelectorAll('a').forEach(function (a) {
        a.addEventListener('click', function () {
          if (a.classList.contains('dropdown-toggle')) return;
          nav.classList.remove('open');
          toggle.setAttribute('aria-expanded', 'false');
        });
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMobileNav);
  } else {
    initMobileNav();
  }
})();
