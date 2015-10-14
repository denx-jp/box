# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.delete-form button').on('click', (e) -> e.stopPropagation())
  $('.delete-form').on('submit', (e) ->
    if !confirm('削除してよろしいですか？')
      e.preventDefault()
      return false
  )
  $('.modal-trigger').leanModal();
