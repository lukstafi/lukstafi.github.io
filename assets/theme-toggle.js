(function () {
  var btn = document.getElementById('theme-btn');
  if (!btn) return;
  btn.addEventListener('click', function () {
    var current = document.documentElement.getAttribute('data-theme');
    var isDark = current === 'dark' ||
      (!current && window.matchMedia('(prefers-color-scheme: dark)').matches);
    var next = isDark ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('theme-preference', next);
    btn.textContent = next === 'dark' ? '\u263e' : '\u263c';
  });
  // Set initial icon
  var saved = document.documentElement.getAttribute('data-theme');
  var dark = saved === 'dark' ||
    (!saved && window.matchMedia('(prefers-color-scheme: dark)').matches);
  btn.textContent = dark ? '\u263e' : '\u263c';
})();
