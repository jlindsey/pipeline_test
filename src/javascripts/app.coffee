#= require vendor/jquery-1.9.1.min
#= require mobileinit
#= require vendor/jquery.mobile-1.3.0.min
#= require vendor/underscore-min
#= require vendor/backbone-min
#= require vendor/handlebars.runtime
#= require templates
#= require_tree ./models
#= require_tree ./collections
#= require_self

$(document).on 'pageinit', '#index', () ->
  $context = $(this)
  users = new Users
  users.on 'reset', (collection) ->
    $context.find('#users-list').prepend Handlebars.templates.users_listview(collection.toJSON())
    $context.find('#users-list').trigger 'create'
    return

  users.fetch()
  return
