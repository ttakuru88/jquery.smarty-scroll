request_animation_frame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || -> (callback) window.setTimeout(callback, 1000 / 60)
cancel_animation_frame = window.cancelAnimationFrame || window.webkitCancelAnimationFrame || -> (id) window.clearTimeout(id)

class MobilePage
  constructor: (@el, @options) ->
    @touch = false

    @model =
      y: 0
      min_y: @el.parent().height() - @el.outerHeight(true)

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
    @throttle = 0
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
    @model.y = @model.min_y if @model.min_y > @model.y

    @translate(0, @model.y)
    @options.scroll?(-@model.y) if (@throttle++ % @options.throttle) == 0

  translate: (x, y) ->
    @el.css
      'transform':         "translate  (#{x}px, #{y}px)"
      '-webkit-transform': "translate3d(#{x}px, #{y}px, 0px)"
      '-ms-transform':     "translate  (#{x}px, #{y}px)"

  inertia_scroll: (v) ->
    @model.y -= v
    @move()

    if v > @options.minMove || v < -@options.minMove
      @timer = request_animation_frame =>
        @inertia_scroll(v * @options.shackle)

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
      throttle: 4
      shackle: 0.93
      minMove: 0.6
    , options

    @each ->
      if navigator.userAgent.match(/iPhone|iPad|iPod|Android/)
        new MobilePage($(@), options)
      else
        new Page($(@), options)

    return @
)(jQuery)
