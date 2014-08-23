# Seeker

A combination search/select box, inspired by those seen here and there on GitHub. [Demo](http://nickb1080.github.io/seeker/).

## Features
- Filtering options
- Opening dropdown with enter key or down key when focused
- Closing dropdown with esc key when search field is focused
- Changing highlighted option in dropdown with up and down keys
- Choosing an option and closing the dropdown with enter key
- Updates underlying `<select>` element on change, and triggers "change" event

## Usage/Installation
Install with bower:
`bower install seeker`

Or through NPM for Browserify:
`npm install seeker`

## API
### Methods
#### `.open()` -> `Seeker instance`
Opens the dropdown and focuses the search field. Returns the instance.

#### `.close()` -> `Seeker instance`
Closes the dropdown. Returns the instance.

#### `.setActive(Number index | Element el | Event evt | String selector | jQuery jqObj)` -> `Seeker instance`
Sets the active (i.e. highlighted) option. If passed an index _n_ then the nth option will be highlighted. If passed a jQuery object, will highlight the first element in the collection if present in options. Otherwise, will apply jQuery to String or DOM Element and likewise locate and highlight that element. If passed an Event (or any object with a .target property), will use that element.

#### `.setSelected(Number index | Element el | Event evt | String selector | jQuery jqObj)` -> `Seeker instance`
Sets the selected option and closes the dropdown if open. Accepts same variety of arguments as `setActive`.

#### `.val()` => `String`
Returns `select.val()` where select is the `<select>` element underlying the Seeker instance. Unlike calling `.val()` on a jQuery-wrapped `select`, *can't be use to set the value~.

### Properties
#### `.activeItem`
the jQuery selection representing the currently active option.

#### `.selectedItem`
The jQuery selection representing the currently selected option.

## Looks like this ([demo](http://nickb1080.github.io/seeker/))
![Seeker](https://dl.dropboxusercontent.com/u/26194775/img/seeker.png)

## Inspired by this
![GitHub search/select box](https://dl.dropboxusercontent.com/u/26194775/img/github-search-select.png)
