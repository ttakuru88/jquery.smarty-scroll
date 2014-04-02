class MobilePage
  constructor: (@el, @options) ->
    @touch = false

    @translate(0, 0)

    @el.on 'touchstart', @touchstart
    @el.on 'touchmove',  @touchmove
    @el.on 'touchend',   @touchend

  touchstart: =>
    return if @touch

    @touch = true

  touchmove: (e) =>
    @options.scroll?(0, e)

  touchend: =>
    @touch = false

  translate: (x, y) ->
    @el.css
      'transform':         "translate  (#{x}, #{y})"
      '-webkit-transform': "translate3d(#{x}, #{y}, 0)"
      '-ms-transform':     "translate  (#{x}, #{y})"

class Page
  constructor: (@el, @options) ->
    @wrapper = @el.parent()
    @wrapper.css('overflow', 'scroll')

    @wrapper.on 'scroll', (e) =>
      @options.scroll?(@wrapper.scrollTop(), e)

(($) ->
  $.fn.smartquescroll = (options) ->
    options = $.extend
      scroll: null
    , options

    @each ->
      if navigator.userAgent.match(/iPhone|iPad|iPod|Android/)
        new MobilePage($(@), options)
      else
        new Page($(@), options)

    return @
)(jQuery)
