
$ () ->

  $(document).delegate '#new_notes_link', 'click', (e) ->
    #console.log('new_notes_link click')
    event.stopPropagation()
    event.preventDefault()
    parent= $(@).data('parent')
    resource =  $(@).data('resource')
    id = $(@).data('id')
    #console.log('parent_div = ' + parent)
    #console.log('resource = ' + resource)
    #console.log('resource_id = ' + id)
    $.ajax
      url: "/commenteux/" + resource + "/" + id + "/new"
      type: "get"
      dataType: "html"
      data:
        "parent_div": parent
      success: (returnData) ->
        #console.log('success')
        #console.log("#" + parent)
        #console.log(returnData)
        if parent
          $("#" + parent ).html(returnData)
        else
          #console.log('no parent')
          $('body').html(returnData)
        @
      error: (e) ->
        alert(e)
        @
    @

  $(document).delegate '#new_comments', 'ajax:success', (e, data, status, xhr) ->
    event.stopPropagation()
    event.preventDefault()
    #console.log('new_comments ajax success')
    parent = $('#new_comments').attr('data-parent')
    if parent
      $('#' + parent).html(xhr.responseText)
    else
      $('body').html(xhr.responseText)

  $(document).delegate '#new_notes_cancelled', 'click', (e) ->
    #console.log('new_notes_cancelled click')
    event.stopPropagation()
    event.preventDefault()
    parent= $(@).data('parent')
    resource =  $(@).data('resource')
    id = $(@).data('id')
    #console.log('parent_div = ' + parent)
    #console.log('resource = ' + resource)
    #console.log('resource_id = ' + id)
    $.ajax
      url: "/commenteux/" + resource + "/" + id + "?parent_div=" + parent
      type: "get"
      dataType: "html"
      data:
        "parent_div": parent
      success: (returnData) ->
        #console.log('success')
        #console.log("#" + parent)
        #console.log(returnData)
        if parent
          $("#" + parent ).html(returnData)
        else
          #console.log('no parent')
          $('body').html(returnData)
        @
      error: (e) ->
        alert(e)
        @
    @
