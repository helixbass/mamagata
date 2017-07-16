import mapKeys from 'lodash/mapKeys'

export default (types, {default: _default = {}} = {}) ->
  toTypeCase = (camelCase) ->
    camelCase
    .replace /[A-Z]/g, '_$&'
    .replace /[a-z]/g, (match) -> match.toUpperCase()

  handlers =
    mapKeys types, (val, key) ->
      toTypeCase key

  (state = _default, action) ->
    {type} = action

    return state unless handler=handlers[type]

    handler state, action
