cached = null

export default ->
  return cached if cached?
  {localStorage} = window
  return unless localStorage

  saved = localStorage.getItem 'saved'
  cached =
    if saved
      JSON.parse saved
    else []

export clear_cache = ->
  cached = null
