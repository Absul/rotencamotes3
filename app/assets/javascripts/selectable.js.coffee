$ ->
  $('#selectable').on 'change', '.selector', (e) ->
    review_type = $(this).val()
    $('#selectable .selectable').parent().hide()
    $("#selectable .selectable.#{review_type}").parent().show()  
