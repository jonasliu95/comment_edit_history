(function () {
  function log() {
    if (!window.console || typeof console.debug !== 'function') { return; }
    var args = Array.prototype.slice.call(arguments);
    args.unshift('[CommentEditHistory]');
    console.debug.apply(console, args);
  }

  function moveIndicatorsIntoHeader() {
    var containers = document.querySelectorAll('.comment-edit-history');
    containers.forEach(function (container) {
      var link = container.querySelector('.comment-edit-history__link');
      var panel = container.querySelector('.comment-edit-history__panel');
      if (!link || !panel) { return; }

      var journal = container.closest('.journal');
      if (!journal) { return; }

      var meta = journal.querySelector('.journal-meta');
      if (!meta) { return; }

      // Prevent duplicates
      if (meta.querySelector('[data-comment-edit-history-indicator="' + panel.id + '"]')) { return; }

      var wrapper = document.createElement('span');
      wrapper.className = 'comment-edit-history__indicator';
      wrapper.setAttribute('data-comment-edit-history-indicator', panel.id);
      wrapper.appendChild(link);

      meta.appendChild(wrapper);
      log('Inserted history indicator for journal #' + (journal.dataset.journalId || journal.id || 'unknown'));
    });
  }

  function togglePanel(event) {
    var link = event.target.closest('.comment-edit-history__link');
    if (!link) { return; }

    var targetId = link.dataset.toggleTarget;
    if (!targetId) { return; }

    var panel = document.getElementById(targetId);
    if (!panel) { return; }

    event.preventDefault();

    var isHidden = panel.hasAttribute('hidden');
    if (isHidden) {
      log('Opening history panel', { panelId: targetId });
      panel.removeAttribute('hidden');
      link.classList.add('comment-edit-history__link--open');
      link.setAttribute('aria-expanded', 'true');
    } else {
      log('Closing history panel', { panelId: targetId });
      panel.setAttribute('hidden', 'hidden');
      link.classList.remove('comment-edit-history__link--open');
      link.setAttribute('aria-expanded', 'false');
    }
  }

  function handleAjaxComplete() {
    moveIndicatorsIntoHeader();
  }

  document.addEventListener('DOMContentLoaded', function () {
    moveIndicatorsIntoHeader();
    log('DOM ready, history indicators initialised');
  });

  document.addEventListener('click', togglePanel);

  // Redmine uses jquery-ujs; listen to ajax completions to reposition links on inline updates
  document.addEventListener('ajax:complete', handleAjaxComplete);
})();
