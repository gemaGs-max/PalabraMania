// lang.js - cambia el idioma de la web entre español e inglés

function setLanguage(lang) {
  const elements = document.querySelectorAll('[data-es]');
  elements.forEach(el => {
    const text = el.getAttribute(`data-${lang}`);
    if (text) el.textContent = text;
  });
  document.documentElement.lang = lang;
}
