import {combineReducers} from 'redux'
import switchingReducer from './helpers/switchingReducer'
import find from 'lodash/find'

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
  completed_animation: (state) ->
    'completed'
  set_current_mixin: ->
    'disabled'
  update_step_arg: ->
    'stopped'
  update_step_duration: ->
    'stopped'
, default: 'disabled'

animation_progress = switchingReducer
  set_animation_progress: (state, {progress}) ->
    progress
, default: 0

animation_seek = switchingReducer
  seek_animation: (state, {time}) ->
    time
  sought_animation: -> null
, default: null

animation_steps = switchingReducer
  set_current_mixin: -> []
  add_animation_step: (state) -> [
    (for step in state
      {
        step...
        active: no
      }
    )...
    changed_args: []
    duration: 400
  ]
  expand_animation_step: (state, {step_index}) ->
    for step, index in state
      if index is step_index
        {
          step...
          active: yes
        }
      else
        step
  set_animation_step_shorthand: (state, {step_index, shorthand}) ->
    for step, index in state
      if index is step_index
        {
          step...
          shorthand
        }
      else
        step
  update_step_duration: (state, {step_index, duration}) ->
    for step, index in state
      if index is step_index
        {
          step...
          duration
        }
      else
        step
  update_step_arg: (state, {step_index, name, value}) ->
    for step, index in state
      if index is step_index
        {changed_args} = step
        {
          step...
          changed_args: do ->
            updated_arg = {name, value}
            if find changed_args, {name}
              for changed_arg in changed_args
                if changed_arg.name is name
                  updated_arg
                else
                  changed_arg
            else
              [
                changed_args...
                updated_arg
              ]
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
  animation_progress, animation_seek
}
