(function() {
  var a, b, c, closeAllSelect, createSelectMenu, i, j, listen, selElmnt, x;

  x = void 0;

  i = void 0;

  j = void 0;

  selElmnt = void 0;

  a = void 0;

  b = void 0;

  c = void 0;


  /*look for any elements with the class "custom-select": */

  listen = function(el, event, handler) {
    if (el.addEventListener) {
      return el.addEventListener(event, handler);
    } else {
      return el.attachEvent('on' + event, function() {
        return handler.call(el);
      });
    }
  };

  closeAllSelect = function(elmnt) {
    var x;
    var i;
    var arrNo, y;
    x = void 0;
    y = void 0;
    i = void 0;
    arrNo = [];
    x = document.getElementsByClassName('select-items');
    y = document.getElementsByClassName('select-selected');
    i = 0;
    while (i < y.length) {
      if (elmnt === y[i]) {
        arrNo.push(i);
      } else {
        y[i].classList.remove('select-arrow-active');
      }
      i++;
    }
    i = 0;
    while (i < x.length) {
      if (arrNo.indexOf(i)) {
        x[i].classList.add('select-hide');
      }
      i++;
    }
  };

  createSelectMenu = function(i, customSelects) {
    var results;
    results = [];
    while (i < x.length) {
      selElmnt = x[i].getElementsByTagName('select')[0];

      /*for each element, create a new DIV that will act as the selected item: */
      if (x[i].getElementsByClassName('select-items').length === 0) {
        a = document.createElement('DIV');
        a.setAttribute('class', 'select-selected');
        a.innerHTML = selElmnt.options[selElmnt.selectedIndex].innerHTML;
        x[i].appendChild(a);

        /*for each element, create a new DIV that will contain the option list: */
        b = document.createElement('DIV');
        b.setAttribute('class', 'select-items select-hide');
        j = 1;
        while (j < selElmnt.length) {

          /*for each option in the original select element,
          create a new DIV that will act as an option item:
           */
          c = document.createElement('DIV');
          c.innerHTML = selElmnt.options[j].innerHTML;
          c.addEventListener('click', function(e) {
            var i;

            /*when an item is clicked, update the original select box,
            and the selected item:
             */
            var h, k, s, y;
            y = void 0;
            i = void 0;
            k = void 0;
            s = void 0;
            h = void 0;
            s = this.parentNode.parentNode.getElementsByTagName('select')[0];
            h = this.parentNode.previousSibling;
            i = 0;
            while (i < s.length) {
              if (s.options[i].innerHTML === this.innerHTML) {
                s.selectedIndex = i;
                h.innerHTML = this.innerHTML;
                y = this.parentNode.getElementsByClassName('same-as-selected');
                k = 0;
                while (k < y.length) {
                  y[k].removeAttribute('class');
                  k++;
                }
                this.setAttribute('class', 'same-as-selected');
                break;
              }
              i++;
            }
            h.click();
          });
          b.appendChild(c);
          j++;
        }
        x[i].appendChild(b);
      }
      a.addEventListener('click', function(e) {

        /*when the select box is clicked, close any other select boxes,
        and open/close the current select box:
         */
        e.stopPropagation();
        closeAllSelect(this);
        this.nextSibling.classList.toggle('select-hide');
        this.classList.toggle('select-arrow-active');
      });
      results.push(i++);
    }
    return results;
  };

  jQuery(function() {
    x = document.getElementsByClassName('custom-select');
    i = 0;
    createSelectMenu(i, x);
    $(document).ajaxComplete(function() {
      return createSelectMenu(i, x);
    });
    document.addEventListener('click', closeAllSelect);
    return $(document).on('click', '.add_fields', function(event) {
      var number, regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).before($(this).data('fields').replace(regexp, time));
      $(this).prev().find('.remove_fields').show();
      number = $('.question-area').length;
      $(this).find('.position').val(number);
      createSelectMenu(i, x);
      return event.preventDefault();
    });
  });

}).call(this);
