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

    @touch = true

  touchmove: (e) =>
    @options.scroll?(0, e)

    now_y = @get_y(e)
    @model.y += now_y - @prev_y
    @prev_y = now_y

    @move()

  touchend: =>
    @touch = false

  move: ->
    @model.y = 0 if @model.y > 0
    @translate(0, @model.y)

  translate: (x, y) ->
    @el.css
      'transform':         "translate  (#{x}px, #{y}px)"
      '-webkit-transform': "translate3d(#{x}px, #{y}px, 0px)"
      '-ms-transform':     "translate  (#{x}px, #{y}px)"

  get_y: (e) ->
    e.originalEvent.touches[0].pageY

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
