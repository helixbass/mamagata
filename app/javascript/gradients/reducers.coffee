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
  updateCurrentMixin: (state, {type, props...}) -> {
    state...
    props...
  }
, default: null

animation_state = switchingReducer
  play_or_pause_animation: (state) ->
    switch state
      when 'playing' then 'paused'
      else 'playing'
  add_animation_step: ->
    'paused'
, default: 'disabled'

animation_steps = switchingReducer
  add_animation_step: (state) -> [
    state...
    sass_args: {}
    css_props: {}
  ]
  set_animation_step_shorthand: (state, {step_index, shorthand}) ->
    for step, index in state
      if index is step_index
        {
          step...
          shorthand
        }
      else
        step
  set_animation_step_prop: (state, {prop, value}) ->
    [steps..., last] = state
    [
      steps...
      {
        last...
        "#{prop}": value
      }
    ]
, default: []

export default combineReducers {
  mixin_args, mixins, current_mixin
  animation_steps, animation_state
}
