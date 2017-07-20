# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
getRandomInt = (min, max) ->
  min = Math.ceil(min)
  max = Math.floor(max)
  Math.floor(Math.random() * (max - min)) + min

export default (obj) ->
  keys = Object.keys obj
  obj[keys[getRandomInt 0, keys.length]]
