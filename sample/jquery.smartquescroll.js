// Generated by CoffeeScript 1.7.1
(function() {
  var MobilePage, Page,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MobilePage = (function() {
    function MobilePage(el, options) {
      this.el = el;
      this.options = options;
      this.touchend = __bind(this.touchend, this);
      this.touchmove = __bind(this.touchmove, this);
      this.touchstart = __bind(this.touchstart, this);
      this.touch = false;
      this.translate(0, 0);
      this.el.on('touchstart', this.touchstart);
      this.el.on('touchmove', this.touchmove);
      this.el.on('touchend', this.touchend);
    }

    MobilePage.prototype.touchstart = function() {
      if (this.touch) {
        return;
      }
      return this.touch = true;
    };

    MobilePage.prototype.touchmove = function(e) {
      var _base;
      return typeof (_base = this.options).scroll === "function" ? _base.scroll(0, e) : void 0;
    };

    MobilePage.prototype.touchend = function() {
      return this.touch = false;
    };

    MobilePage.prototype.translate = function(x, y) {
      return this.el.css({
        'transform': "translate  (" + x + ", " + y + ")",
        '-webkit-transform': "translate3d(" + x + ", " + y + ", 0)",
        '-ms-transform': "translate  (" + x + ", " + y + ")"
      });
    };

    return MobilePage;

  })();

  Page = (function() {
    function Page(el, options) {
      this.el = el;
      this.options = options;
      this.wrapper = this.el.parent();
      this.wrapper.css('overflow', 'scroll');
      this.wrapper.on('scroll', (function(_this) {
        return function(e) {
          var _base;
          return typeof (_base = _this.options).scroll === "function" ? _base.scroll(_this.wrapper.scrollTop(), e) : void 0;
        };
      })(this));
    }

    return Page;

  })();

  (function($) {
    return $.fn.smartquescroll = function(options) {
      options = $.extend({
        scroll: null
      }, options);
      this.each(function() {
        if (navigator.userAgent.match(/iPhone|iPad|iPod|Android/)) {
          return new MobilePage($(this), options);
        } else {
          return new Page($(this), options);
        }
      });
      return this;
    };
  })(jQuery);

}).call(this);