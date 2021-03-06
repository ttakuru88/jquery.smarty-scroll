(function() {
  var MobilePage, Page, cancel_animation_frame, request_animation_frame,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  request_animation_frame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || function() {
    return callback(window.setTimeout(callback, 1000 / 60));
  };

  cancel_animation_frame = window.cancelAnimationFrame || window.webkitCancelAnimationFrame || function() {
    return id(window.clearTimeout(id));
  };

  MobilePage = (function() {
    function MobilePage(el, options1) {
      this.el = el;
      this.options = options1;
      this.touchend = bind(this.touchend, this);
      this.touchmove = bind(this.touchmove, this);
      this.touchstart = bind(this.touchstart, this);
      this.touch = false;
      this.model = {
        y: 0,
        min_y: this.el.parent().height() - this.el.outerHeight(true)
      };
      this.move();
      this.prev_y = 0;
      this.el.on('touchstart', this.touchstart);
      this.el.on('touchmove', this.touchmove);
      this.el.on('touchend', this.touchend);
    }

    MobilePage.prototype.touchstart = function(e) {
      if (this.touch) {
        return;
      }
      this.prev_y = this.get_y(e);
      this.velocity = 0;
      this.throttle = 0;
      this.stop_scroll();
      return this.touch = true;
    };

    MobilePage.prototype.touchmove = function(e) {
      var now_y;
      now_y = this.get_y(e);
      this.velocity = this.prev_y - now_y;
      this.model.y -= this.velocity;
      this.prev_y = now_y;
      if (this.model.y < 0 && this.model.min_y < this.model.y) {
        e.preventDefault();
      }
      return this.move();
    };

    MobilePage.prototype.touchend = function() {
      this.touch = false;
      return this.inertia_scroll(this.velocity);
    };

    MobilePage.prototype.move = function() {
      var base;
      if (this.model.y > 0) {
        this.model.y = 0;
      }
      if (this.model.min_y > this.model.y) {
        this.model.y = this.model.min_y;
      }
      this.translate(0, this.model.y);
      if ((this.throttle++ % this.options.throttle) === 0) {
        return typeof (base = this.options).scroll === "function" ? base.scroll(-this.model.y) : void 0;
      }
    };

    MobilePage.prototype.translate = function(x, y) {
      return this.el.css({
        'transform': "translate  (" + x + "px, " + y + "px)",
        '-webkit-transform': "translate3d(" + x + "px, " + y + "px, 0px)",
        '-ms-transform': "translate  (" + x + "px, " + y + "px)"
      });
    };

    MobilePage.prototype.inertia_scroll = function(v) {
      this.model.y -= v;
      this.move();
      if (v > this.options.minMove || v < -this.options.minMove) {
        return this.timer = request_animation_frame((function(_this) {
          return function() {
            return _this.inertia_scroll(v * _this.options.shackle);
          };
        })(this));
      }
    };

    MobilePage.prototype.stop_scroll = function() {
      return cancel_animation_frame(this.timer);
    };

    MobilePage.prototype.get_y = function(e) {
      return e.originalEvent.touches[0].pageY;
    };

    return MobilePage;

  })();

  Page = (function() {
    function Page(el, options1) {
      this.el = el;
      this.options = options1;
      this.wrapper = this.el.parent();
      this.wrapper.css('overflow', 'scroll');
      this.wrapper.on('scroll', (function(_this) {
        return function(e) {
          var base;
          return typeof (base = _this.options).scroll === "function" ? base.scroll(_this.wrapper.scrollTop()) : void 0;
        };
      })(this));
    }

    return Page;

  })();

  (function($) {
    return $.fn.smartyScroll = function(options) {
      options = $.extend({
        scroll: null,
        throttle: 4,
        shackle: 0.93,
        minMove: 0.6
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
