import {capitalize} from 'underscore.string'

export default (str) ->
  capitalize str.replace /-([a-z0-9])/g, ' $1'
