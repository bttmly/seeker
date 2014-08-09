if typeof require is "function"
  $ = jQuery = require "jquery"
else
  { jQuery } = window
  $ = jQuery

unless String::contains
  String::contains = ->
    String::indexOf.apply( this, arguments ) isnt -1

slice = Function::call.bind Array::slice

# key codes
ENTER = 13
ESC = 27
UP = 38
DOWN = 40

body = $ "body"

class SearchBox
  constructor: ( el ) ->
    @root = $ el
    @button = @root.find ".current-selection"
    @current = @root.find ".selected-item"
    @dropdown = @root.find ".dropdown"
    @searchField = @root.find ".search-field"
    @items = @root.find ".option-list--item"
    @selection = @root.find ".selection"
    @closeMark = @root.find ".close"
    @isOpen = false
    @filteredOptions = null

    @selectedItem = null
    @activeItem = null

    @root.toggleClass "is-open", false

    @root.on "keyup", ( evt ) =>
      if evt.which is ENTER or evt.which is DOWN
        @open()

    body.on "click", @close
    @root.on "click", ( evt ) ->
      evt.stopPropagation()

    @button.click @toggleState
    @searchField.keyup @handleInput
    @closeMark.click  @close
    @items.click @selectItem
    @items.mouseover @changeActive
    @selectItem @items.first()

  open: =>
    unless @isOpen
      @isOpen = true
      @root.toggleClass "is-open", @isOpen
      @searchField.focus()

  close: =>
    if @isOpen
      @isOpen = false
      @root.toggleClass "is-open", @isOpen
      @items.show()
      @searchField.val( "" )
      @root.focus()

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
        @changeActive prev
    else if evt.which is DOWN
      next = @activeItem.next()
      if next.length
        @changeActive next
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
    @changeActive first

  changeActive: ( param ) =>
    unless param instanceof jQuery
      # assume param is event
      param = $ param.target
    @items.removeClass "is-active"
    param.addClass "is-active"
    @activeItem = param

  switchToActive: =>
    @selectItem @activeItem

  on: ->
    args = @bindMethods arguments
    $.fn.on.apply @root, args
    @

  trigger: ->
    $.fn.trigger.apply @root, arguments
    @

  val: ( param ) ->
    if param?
      @value = param
      @
    else
      @value

  selectItem: ( param ) =>
    unless param instanceof jQuery
      # assume param is event
      param = $ param.target
    @items.removeClass "is-selected"
    param.addClass "is-selected"
    @selectedItem = param
    @changeActive param
    @current.html param.html()
    @val param.html()
    @trigger "change"
    @close()

  bindMethods: ( arr ) ->
    arr = slice arr
    for item, i in arr
      if typeof item is "function"
        arr[i] = item.bind @
    arr

exports = exports ? this
exports.SearchBox = SearchBox
exports.jQuery = jQuery
