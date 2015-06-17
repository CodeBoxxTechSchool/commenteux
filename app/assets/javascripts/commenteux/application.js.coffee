$ () ->
  $(document).delegate '#new_notes_link', 'click', (e) ->
    #console.log('new_notes_link click')
    e.stopPropagation()
    e.preventDefault()
    parent = $(@).data('parent')
    resource = $(@).data('resource')
    id = $(@).data('id')
    roles = $(@).data('roles')
    #console.log('parent_div = ' + parent)
    #console.log('resource = ' + resource)
    #console.log('resource_id = ' + id)
    $.ajax
      url: "/commenteux/" + resource + "/" + id + "/new"
      type: "get"
      dataType: "html"
      data:
        "parent_div": parent
        "roles": roles
      success: (returnData) ->
        #console.log('success')
        #console.log("#" + parent)
        #console.log(returnData)
        if parent and parent != 'null'
          $("#" + parent).html(returnData)
        else
          #console.log('no parent')
          $('body').html(returnData)
        @
      error: (e) ->
        alert(e)
        @
    @

  $(document).delegate '#new_comments', 'ajax:success', (e, data, status, xhr) ->
    e.stopPropagation()
    e.preventDefault()
    #console.log('new_comments ajax success')
    parent = $('#new_comments').attr('data-parent')
    if parent and parent != 'null'
      $('#' + parent).html(xhr.responseText)
    else
      $('body').html(xhr.responseText)

  $(document).delegate '#new_notes_cancelled', 'click', (e) ->
    #console.log('new_notes_cancelled click')
    e.stopPropagation()
    e.preventDefault()
    parent = $(@).data('parent')
    resource = $(@).data('resource')
    id = $(@).data('id')
    roles = $(@).data('roles')
    #console.log('parent_div = ' + parent)
    #console.log('resource = ' + resource)
    #console.log('resource_id = ' + id)
    $.ajax
      url: "/commenteux/" + resource + "/" + id + "?parent_div=" + parent
      type: "get"
      dataType: "html"
      data:
        "parent_div": parent
        "roles": roles
      success: (returnData) ->
        #console.log('success')
        #console.log("#" + parent)
        #console.log(returnData)
        if parent
          $("#" + parent).html(returnData)
        else
          #console.log('no parent')
          $('body').html(returnData)
        @
      error: (e) ->
        alert(e)
        @
    @
