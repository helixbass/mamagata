import {combineReducers} from 'redux'
import switchingReducer from './helpers/switchingReducer'

mixin_args = switchingReducer
  setCurrentMixin: (state, {mixin: {params}}) ->
    for {name, default: _default} in params
      {
        name
        value: _default
      }

  updateMixinArg: (state, {name, value}) ->
    for arg in state
      if arg.name is name
        {name, value}
      else arg

mixins = switchingReducer
  setMixins: (state, {mixins}) ->
    mixins

current_mixin = switchingReducer
  setCurrentMixin: (state, {mixin}) ->
    mixin
  setCurrentMixinCss: (state, {css}) -> {
    state...
    css
  }
, default: null

export default combineReducers {
  mixin_args, mixins, current_mixin
}
