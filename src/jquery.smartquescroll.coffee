class MobilePage
  constructor: (@el, @options) ->

class Page
  constructor: (@el, @options) ->
    @wrapper = @el.parent()
    @wrapper.css('overflow', 'scroll')

    @wrapper.on 'scroll', (e) =>
      @options.scroll?(e)

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
