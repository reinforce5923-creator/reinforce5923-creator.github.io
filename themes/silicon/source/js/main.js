(function () {
  var navToggle = document.querySelector('.nav-toggle');
  var nav = document.querySelector('.site-nav');
  if (navToggle && nav) {
    navToggle.addEventListener('click', function () {
      var open = nav.classList.toggle('is-open');
      navToggle.setAttribute('aria-expanded', String(open));
    });
  }

  var topButton = document.querySelector('.back-to-top');
  if (topButton) {
    window.addEventListener('scroll', function () {
      topButton.classList.toggle('is-visible', window.scrollY > 420);
    });
    topButton.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  var counterNamespace = 'reinforce5923-creator-github-io';
  var counterCache = {};

  function counterKey(path) {
    var clean = (path || window.location.pathname || '')
      .replace(/^https?:\/\/[^/]+/i, '')
      .split('#')[0]
      .split('?')[0]
      .replace(/^\/+|\/+$/g, '') || 'home';
    var hash = 2166136261;
    for (var i = 0; i < clean.length; i += 1) {
      hash ^= clean.charCodeAt(i);
      hash += (hash << 1) + (hash << 4) + (hash << 7) + (hash << 8) + (hash << 24);
    }
    return 'post-' + (hash >>> 0).toString(16);
  }

  function counterUrl(action, key) {
    var base = 'https://api.counterapi.dev/v1/' + counterNamespace + '/' + key;
    return action === 'up' ? base + '/up' : base + '/';
  }

  function requestCounter(action, key) {
    return fetch(counterUrl(action, key), { cache: 'no-store' }).then(function (response) {
      if (!response.ok) {
        if (action === 'get' && (response.status === 400 || response.status === 404)) {
          return { count: 0 };
        }
        throw new Error('Counter request failed');
      }
      return response.json();
    });
  }

  function setCounterText(element, value) {
    var count = Number(value);
    element.textContent = Number.isFinite(count) && count >= 0 ? String(count) : '0';
  }

  function loadPostCounter(element) {
    var key = counterKey(element.getAttribute('data-counter-path'));
    if (!counterCache[key]) {
      counterCache[key] = requestCounter('get', key).catch(function () {
        return { count: 0 };
      });
    }
    counterCache[key].then(function (data) {
      setCounterText(element, data.count);
    });
  }

  document.querySelectorAll('[data-post-view-counter]').forEach(loadPostCounter);

  var pageCounter = document.querySelector('[data-page-view-counter]');
  if (pageCounter) {
    requestCounter('up', counterKey(pageCounter.getAttribute('data-counter-path')))
      .then(function (data) {
        setCounterText(pageCounter, data.count);
      })
      .catch(function () {
        setCounterText(pageCounter, 0);
      });
  }

  document.querySelectorAll('pre').forEach(function (pre) {
    var button = document.createElement('button');
    button.className = 'copy-code';
    button.type = 'button';
    button.textContent = 'Copy';
    button.addEventListener('click', function () {
      var code = pre.querySelector('code');
      var text = code ? code.innerText : pre.innerText;
      navigator.clipboard.writeText(text).then(function () {
        button.textContent = 'Copied';
        setTimeout(function () {
          button.textContent = 'Copy';
        }, 1500);
      });
    });
    pre.appendChild(button);
  });

  var input = document.getElementById('site-search');
  var results = document.getElementById('search-results');
  var cache = null;

  function parseSearchXml(xmlText) {
    var doc = new DOMParser().parseFromString(xmlText, 'application/xml');
    return Array.prototype.map.call(doc.querySelectorAll('entry'), function (entry) {
      return {
        title: (entry.querySelector('title') || {}).textContent || '',
        url: (entry.querySelector('url') || {}).textContent || '',
        content: (entry.querySelector('content') || {}).textContent || ''
      };
    });
  }

  function renderResults(query) {
    if (!results || !cache) return;
    var q = query.trim().toLowerCase();
    if (!q) {
      results.innerHTML = '';
      results.classList.remove('is-open');
      return;
    }
    var matches = cache.filter(function (item) {
      return (item.title + ' ' + item.content).toLowerCase().indexOf(q) !== -1;
    }).slice(0, 8);
    results.innerHTML = matches.length ? matches.map(function (item) {
      return '<a href="' + item.url + '"><strong>' + item.title + '</strong><span>' + item.content.replace(/<[^>]+>/g, '').slice(0, 80) + '</span></a>';
    }).join('') : '<p>没有找到相关文章</p>';
    results.classList.add('is-open');
  }

  if (input && results && window.SILICON_BLOG) {
    fetch(window.SILICON_BLOG.searchPath)
      .then(function (response) { return response.text(); })
      .then(function (text) { cache = parseSearchXml(text); })
      .catch(function () { cache = []; });
    input.addEventListener('input', function () {
      renderResults(input.value);
    });
    document.addEventListener('click', function (event) {
      if (!event.target.closest('.search-bar')) {
        results.classList.remove('is-open');
      }
    });
  }
}());
