export default (obj, objs...) ->
  for _obj in objs
    for key, val of _obj
      obj[key] = val
  obj
