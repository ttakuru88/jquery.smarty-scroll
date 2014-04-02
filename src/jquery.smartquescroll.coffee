request_animation_frame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || -> (callback) window.setTimeout(callback, 1000 / 60)
cancel_animation_frame = window.cancelAnimationFrame || window.webkitCancelAnimationFrame || -> (id) window.clearTimeout(id)

class MobilePage
  constructor: (@el, @options) ->
    @touch = false

    @model = {y: 0}
    @move()

    @prev_y = 0

    @el.on 'touchstart', @touchstart
    @el.on 'touchmove',  @touchmove
    @el.on 'touchend',   @touchend

  touchstart: (e) =>
    e.preventDefault()
    return if @touch

    @prev_y = @get_y(e)
    @velocity = 0
    @stop_scroll()

    @touch = true

  touchmove: (e) =>
    now_y = @get_y(e)
    @velocity = @prev_y - now_y
    @model.y -= @velocity
    @prev_y = now_y

    @move()

  touchend: =>
    @touch = false
    @inertia_scroll(@velocity)

  move: ->
    @model.y = 0 if @model.y > 0
    @translate(0, @model.y)
    @options.scroll?(0, @model.y)

  translate: (x, y) ->
    @el.css
      'transform':         "translate  (#{x}px, #{y}px)"
      '-webkit-transform': "translate3d(#{x}px, #{y}px, 0px)"
      '-ms-transform':     "translate  (#{x}px, #{y}px)"

  inertia_scroll: (v) ->
    @model.y -= v
    @move()

    if v > 0.6 || v < -0.6
      @timer = request_animation_frame =>
        @inertia_scroll(v * 0.92)

  stop_scroll: ->
    cancel_animation_frame(@timer)

  get_y: (e) ->
    e.originalEvent.touches[0].pageY

class Page
  constructor: (@el, @options) ->
    @wrapper = @el.parent()
    @wrapper.css('overflow', 'scroll')

    @wrapper.on 'scroll', (e) =>
      @options.scroll?(@wrapper.scrollTop())

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
