Seeker = window.Seeker

html = """
  <select id="select">
    <option>Zero</option>
    <option>One</option>
    <option>Two</option>
    <option>Three</option>
  </select>
"""

ENTER = 13
ESC = 27
UP = 38
DOWN = 40

timeout = ( delay, cb ) ->
  setTimeout cb, delay

makeKeyEvt = ( which, type = "up" ) ->
  e = jQuery.Event "key#{ type }"
  e.which = which
  e

makeSelect = ->
  $ html

area = $ "#test"

seeker = undefined
select = undefined
dropdown = undefined
current = undefined

beforeEach ->
  select = do makeSelect
  area.append select
  seeker = new Seeker select
  dropdown = seeker.find ".dropdown"

afterEach ->
  area.empty()

describe "Seeker constructor & init", ->
  it "Is a constructor function", ->
    Seeker.should.be.a "function"

  it "Should build from an existing select", ->
    seeker.find( "li" ).length.should.equal 4

  it "Should hide the <select>", ->
    select[0].style.display.should.equal "none"


describe "UI behavior", ->
  it "Should toggle state on clicked", ->
    seeker.isOpen.should.be.false
    seeker.is( ".is-open" ).should.be.false

    seeker.button.click()
    seeker.isOpen.should.be.true
    seeker.is( ".is-open" ).should.be.true

    seeker.button.click()
    seeker.is( ".is-open" ).should.be.false
    seeker.isOpen.should.be.false

  it "Should open when focused and ENTER is pressed", ->
    seeker.isOpen.should.be.false
    seeker.is( ".is-open" ).should.be.false

    seeker.trigger makeKeyEvt ENTER
    seeker.isOpen.should.be.true
    seeker.is( ".is-open" ).should.be.true

  it "Should open when focused and DOWN is pressed", ->
    seeker.isOpen.should.be.false
    seeker.is( ".is-open" ).should.be.false

    seeker.trigger makeKeyEvt DOWN
    seeker.isOpen.should.be.true
    seeker.is( ".is-open" ).should.be.true

  it "Should close when search is focused and ESC is pressed", ->
    seeker.isOpen.should.be.false
    seeker.is( ".is-open" ).should.be.false
    seeker.trigger makeKeyEvt DOWN
    area.find( ":focus" ).trigger makeKeyEvt ESC
    seeker.is( ".is-open" ).should.be.false

  it "Should change active when search is focused and DOWN is pressed" , ->
    seeker.isOpen.should.be.false
    seeker.is( ".is-open" ).should.be.false
    seeker.trigger makeKeyEvt DOWN
    seeker.is( ".is-open" ).should.be.true

  it "Should change active member when the active member is active", ->


do mocha.run

















