import isArray from 'lodash/isArray'

export default ( obj ) ->
  if isArray obj then obj else [obj]
