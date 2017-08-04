export default ->
  {localStorage} = window
  return unless localStorage

  saved = localStorage.getItem 'saved'
  return [] unless saved
  JSON.parse saved
