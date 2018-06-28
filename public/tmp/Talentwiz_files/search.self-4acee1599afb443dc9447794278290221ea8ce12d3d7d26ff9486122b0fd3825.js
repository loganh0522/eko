(function() {
  jQuery(function() {
    var autoComplete, autocompleteCustom, debounceTimeout, searchAuto, searchEvents, searchField, searchFieldAuto, searchFieldDropDown, searchInput, searchRequest, searchText, submitLink;
    if (history && history.pushState) {
      $(function() {
        $('#main-container').on('click', '.pagination a', function() {
          var linkUrl;
          linkUrl = $(this).attr('href').split("?")[1];
          history.pushState({}, "", "?" + linkUrl);
          $.getScript(this.href);
          return false;
        });
        $(window).bind('popstate', function() {
          $.getScript(location.href);
        });
      });
    }
    searchRequest = null;
    debounceTimeout = null;
    searchInput = $('.filter, input[name=\'owner\']');
    searchText = $('.search-field');
    searchAuto = $('.search-field-auto');
    autoComplete = $('.autocomplete');
    autocompleteCustom = $('.autocompleteCustom');
    searchEvents = function() {
      var action, i, len, linkUrl, links, n, param, url;
      if (searchRequest) {
        searchRequest.abort();
      }
      action = $("#search-form").attr('action');
      param = $(this).attr('name') + "=" + $(this).attr('value');
      url = window.location;
      links = $('.filter-link');
      for (i = 0, len = links.length; i < len; i++) {
        n = links[i];
        linkUrl = $(n).attr('href').split("?")[0];
        n.setAttribute('href', linkUrl + "?" + $("#search-form").serialize());
      }
      searchRequest = $.get(action, $("#search-form").serialize(), null, "script");
      return history.pushState({}, "", "?" + $("#search-form").serialize());
    };
    searchField = function() {
      var action, i, len, linkUrl, links, n, param, url;
      if (searchRequest) {
        searchRequest.abort();
      }
      action = $("#search-form").attr('action');
      param = $(this).attr('name') + "=";
      url = window.location;
      links = $('.filter-link');
      for (i = 0, len = links.length; i < len; i++) {
        n = links[i];
        linkUrl = $(n).attr('href').split("?")[0];
        n.setAttribute('href', linkUrl + "?" + $("#search-form").serialize());
      }
      $.get(action, $("#search-form").serialize(), null, "script");
      return history.pushState({}, "", "?" + $("#search-form").serialize());
    };
    searchFieldAuto = function() {
      var action;
      if (searchRequest) {
        searchRequest.abort();
      }
      action = $("#search-form").attr('action');
      return $.get(action, $("#search-form").serialize(), null, "script");
    };
    searchFieldDropDown = function() {
      var action;
      if (searchRequest) {
        searchRequest.abort();
      }
      action = $('#dropdown-autocomplete').attr('action');
      return $.get(action, $('#dropdown-autocomplete').serialize(), null, "script");
    };
    searchAuto.on('keyup', function(event) {
      clearTimeout(debounceTimeout);
      debounceTimeout = setTimeout(searchFieldAuto, 500);
    });
    searchInput.on('click', function(event) {
      clearTimeout(debounceTimeout);
      debounceTimeout = setTimeout(searchEvents, 500);
    });
    searchText.on('keyup', function(event) {
      clearTimeout(debounceTimeout);
      debounceTimeout = setTimeout(searchField, 500);
    });
    $(".change-containers-nav").on('click', '.change-aj', function(event) {
      $.getScript(this.href);
      return history.pushState(null, "", this.href);
    });
    $(window).bind('popstate', function() {
      $.getScript(location.url);
    });
    $('#main-container').on('click', '.glyphicon', function(event) {
      if ($(this).hasClass('glyphicon-minus')) {
        $(this).parent().next().hide();
        $(this).hide();
        $(this).next().show();
      } else if ($(this).hasClass('glyphicon-plus')) {
        $(this).parent().next().show();
        $(this).hide();
        $(this).prev().show();
      }
    });
    submitLink = function() {
      if (searchRequest) {
        searchRequest.abort();
      }
      return $.post('/job_seeker/attachments', {
        link: $('#link-up').val()
      }, null, "script");
    };
    $(document).on('keyup', '#link-up', function(event) {
      if ($(this).val().length > 3) {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(submitLink, 500);
      }
    });
    return $(document).one('click', '#client-action', function(event) {
      var customAutocomplete, linkUp, searchFieldDropAuto;
      searchAuto = $('.search-field-auto');
      linkUp = $('#link-up');
      searchRequest = null;
      debounceTimeout = null;
      autocompleteCustom = $('.autocompleteCustom');
      searchFieldDropAuto = function() {
        var action;
        if (searchRequest) {
          searchRequest.abort();
        }
        action = $('#dropdown-autocomplete').attr('action');
        return $.get(action, $('#dropdown-autocomplete').serialize(), null, "script");
      };
      searchAuto.on('keyup', function(event) {
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(searchFieldDropAuto, 500);
      });
      customAutocomplete = function(search) {
        var action;
        if (searchRequest) {
          searchRequest.abort();
        }
        action = search.attr('id');
        return $.get('/business/' + action + '/autocomplete', {
          term: search.val()
        }, null, "script");
      };
      return $(document).on('keyup', '.autocompleteCustom', function(event) {
        var search;
        clearTimeout(debounceTimeout);
        search = $(this);
        debounceTimeout = setTimeout(customAutocomplete, 500, search);
      });
    });
  });

}).call(this);
