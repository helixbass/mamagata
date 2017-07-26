import dashed_to_camel from './dashed_to_camel'
import extend from './extend'
import fromPairs from 'lodash/fromPairs'

export default ({css}) ->
  props = {}
  css.replace ///
    \n
    \s +
    ([a-z\-] +) # name
    :
    \s *
    ([^;] +) # value
    ;
  ///g, (all, name, value) ->
    props[dashed_to_camel name] = value
  props
