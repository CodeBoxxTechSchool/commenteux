$(document).on 'click', '#new_notes_link', (e) ->
  e.stopPropagation()
  e.preventDefault()
  parent = $(@).data('parent')
  resource = $(@).data('resource')
  id = $(@).data('id')
  roles = $(@).data('roles')
  display_list_notes = $(@).data('display-list-notes')
  $.ajax
    url: "/commenteux/" + resource + "/" + id + "/new"
    type: "get"
    dataType: "html"
    data:
      "parent_div": parent
      "roles": roles
      "display_list_notes": display_list_notes
    success: (returnData) ->
      if parent and parent != 'null'
        $("#" + parent).html(returnData)
      else
        $('body').html(returnData)
      @
    error: (e) ->
      alert(e)
      @
  @

$(document).on 'ajax:success', '#new_comments', (e, data, status, xhr) ->
  e.stopPropagation()
  e.preventDefault()
  parent = $('#new_comments').attr('data-parent')
  if parent and parent != 'null'
    $("#" + parent).html(xhr.responseText)
  else
    $('body').html(xhr.responseText)
  @

$(document).on 'click', '#new_notes_cancelled', (e) ->
  e.stopPropagation()
  e.preventDefault()
  parent = $(@).data('parent')
  resource = $(@).data('resource')
  id = $(@).data('id')
  roles = $(@).data('roles')
  display_list_notes = $(@).data('display-list-notes')
  $.ajax
    url: "/commenteux/" + resource + "/" + id + "?parent_div=" + parent
    type: "get"
    dataType: "html"
    data:
      "parent_div": parent
      "roles": roles
      "display_list_notes": display_list_notes
    success: (returnData) ->
      if parent
        $("#" + parent).html(returnData)
      else
        $('body').html(returnData)
      @
    error: (e) ->
      alert(e)
      @
  @
