import {capitalize} from 'underscore.string'

export default (str) ->
  capitalize str.replace /-([a-z])/, ' $1'
