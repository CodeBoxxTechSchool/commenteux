$(document).on 'click', '#new_notes_link', (e) ->
  e.stopPropagation()
  e.preventDefault()

  resource = $(@).data('resource')
  id = $(@).data('id')
  parent = $(@).data('parent')
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

$(document).on 'ajax:success', '#edit_comments', (e, data, status, xhr) ->
  e.stopPropagation()
  e.preventDefault()

  parent = $('#edit_comments').attr('data-parent')

  if parent and parent != 'null'
    $("#" + parent).html(xhr.responseText)
  else
    $('body').html(xhr.responseText)
  @

$(document).on 'click', '#new_notes_cancelled', (e) ->
  e.stopPropagation()
  e.preventDefault()

  resource = $(@).data('resource')
  id = $(@).data('id')
  parent = $(@).data('parent')
  roles = $(@).data('roles')
  display_list_notes = $(@).data('display-list-notes')

  $.ajax
    url: "/commenteux/" + resource + "/" + id
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

$(document).on 'click', '.remove_comment', (e) ->
  e.stopPropagation()
  e.preventDefault()

  resource = $(@).data('resource')
  resource_id = $(@).data('resource-id')
  id = $(@).data('id')
  comment_role = $(@).data('comment-role')

  $.ajax
    url: "/commenteux/" + resource + "/" + resource_id + "?id=" + id + "&comment_role=" + comment_role
    type: "delete"
    dataType: "html"
    success:
      $(".comment[data-id='" + id + "']").remove()
    error: (e) ->
      alert(e)
      @
  @

$(document).on 'click', '.edit_comment', (e) ->
  e.stopPropagation()
  e.preventDefault()

  resource = $(@).data('resource')
  resource_id = $(@).data('resource-id')
  id = $(@).data('id')
  comment_role = $(@).data('comment-role')
  parent = $(@).data('parent')
  roles = $(@).data('roles')
  display_list_notes = $(@).data('display-list-notes')

  $.ajax
    url: "/commenteux/" + resource + "/" + resource_id + "/" + id + "/edit"
    type: "get"
    dataType: "html"
    data:
      "comment_role": comment_role
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
