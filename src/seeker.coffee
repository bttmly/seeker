if typeof require is "function"
  $ = jQuery = require "jquery"
else
  { jQuery } = window
  $ = jQuery

unless String::contains
  String::contains = ->
    String::indexOf.apply( this, arguments ) isnt -1

interpolate = ( str, obj ) ->
  str.replace /\{([^{}]*)\}/g, ( a, b ) ->
    r = obj[b]
    if typeof r is "string" or typeof r is "number" then r else a

slice = Function::call.bind Array::slice
map = Function::call.bind Array::map
body = $ "body"

# key codes
ENTER = 13
ESC = 27
UP = 38
DOWN = 40

template = """
  <div class="seeker">
    <div class="current-selection">
      <i class="icon"></i>
      <span class="selected-item"></span>
    </div>
    <div class="dropdown">
      <div class="dropdown--top">
        <div class="dropdown--label">
          Select branch:
          <div class="close">&times;</div>
        </div>
        <div class="dropdown--search-bar">
          <input class="search-field"></input>
        </div>
      </div>
      <div class="dropdown--options">
        <ul class="option-list">
          {options}
        </ul>
      </div>
    </div>
  </div>
"""

normalize = ( param ) ->
  # already jQuery
  if param instanceof jQuery
    param
  # is event
  else if param.target
    $ param.target
  # dom nodes, strings
  else
    $ param

buildHtml = ( el ) ->
  params = {}
  params.options = map el.find( "option" ), ( option ) ->
    "<li class='option-list--item'>#{ option.innerHTML }</li>"
  .join "\n"
  interpolate template, params

class Seeker extends jQuery
  constructor: ( el ) ->
    html = buildHtml el
    jQuery.fn.init.call this, html
    @el = el
    @button = @find ".current-selection"
    @current = @find ".selected-item"
    @dropdown = @find ".dropdown"
    @searchField = @find ".search-field"
    @items = @find ".option-list--item"
    @selection = @find ".selection"
    @closeMark = @find ".close"

    @isOpen = false
    @filteredOptions = null
    @selectedItem = null
    @activeItem = null
    # set up event listeners
    body.on "click", @close
    @click ( evt ) ->
      evt.stopPropagation()
    @keyup ( evt ) =>
      if evt.which is ENTER or evt.which is DOWN
        @open()
    @button.click @toggleState
    @searchField.keyup @handleInput
    @closeMark.click  @close
    @items.click @setSelected
    @items.mouseover @setActive

    this
      .wireOriginal()
      .setSelected @items.first()
      .toggleClass "is-open", false
      .el.hide().after @

  wireOriginal: =>
    # <select> listens for changes to Seeker
    @on "change", =>
      @el.find( "option" ).each ( i, el ) =>
        if el.innerHTML is @selectedItem[0].innerHTML
          el.selected = true
          false

    # Seeker listens for changes to <select>
    @el.on "change", =>
      selected = @el.find ":selected"
      @items.each ( i, el ) =>
        if el.innerHTML is selected[0].innerHTML
          @setSelected el, true
          false

    # Properly set up tabIndex
    @prop "tabIndex", @el.prop "tabIndex"
    @el.prop "tabIndex", -1

    @

  open: =>
    unless @isOpen
      @isOpen = true
      @toggleClass "is-open", @isOpen
      @searchField.focus()

  close: =>
    if @isOpen
      @isOpen = false
      @toggleClass "is-open", @isOpen
      @items.show()
      @searchField.val ""
      @focus()

  toggleState: =>
    if @isOpen then @close() else @open()

  handleInput: ( evt ) =>
    if evt.which is ESC
      @close()
    else if evt.which is ENTER
      @switchToActive()
      evt.stopPropagation()
    else if evt.which is UP
      prev = @activeItem.prev()
      if prev.length
        @setActive prev
    else if evt.which is DOWN
      next = @activeItem.next()
      if next.length
        @setActive next
    else
      @filterResults()

  filterResults: =>
    str = @searchField.val().toLowerCase()
    first = undefined
    @items.each ->
      $this = $ @
      against = $this.html().toLowerCase()
      if against.contains( str )
        $this.show()
        first = $this unless first
      else
        $this.hide()
    @setActive first

  switchToActive: =>
    @setSelected @activeItem

  val: ->
    @el.val()

  setActive: ( param ) =>
    param = normalize param
    if param isnt @activeItem
      @activeItem = normalize param
      @items.removeClass "is-active"
      @activeItem.addClass "is-active"
    @

  setSelected: ( param, quiet ) =>
    param = normalize param
    if param isnt @selectedItem
      @selectedItem = param
      @items.removeClass "is-selected"
      @selectedItem.addClass "is-selected"
      @current.html @selectedItem.html()
      @trigger "change" unless quiet
      @setActive @selectedItem
    @close()
    @


  # wrapper fix, a la space pen
  pushStack: ( elems ) ->
    ret = jQuery.merge jQuery(), elems
    ret.prevObject = this
    ret.context = @context
    ret

  # wrapper fix, a la space pen
  end: ->
    @prevObject ? jQuery null

exports = exports ? this
exports.Seeker = Seeker
exports.jQuery = jQuery
