export default (str) ->
  str.replace /-([a-z])/g, (all, lower) ->
    lower.toUpperCase()
