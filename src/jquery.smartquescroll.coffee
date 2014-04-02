class Page
  constructor: (@el, @options) ->

(($) ->
  $.fn.smartquescroll = (options) ->
    options = $.extend
      tmp: 1
    , options

    @each ->
      new Page($(@), options)

    return @
)(jQuery)
