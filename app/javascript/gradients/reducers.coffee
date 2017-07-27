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

reset_animation = switchingReducer
  set_current_mixin: ->
    yes
  update_loop: ->
    yes
  delete_step_arg: ->
    yes
  update_step_arg: ->
    yes
  update_mixin_arg: ->
    yes
  update_step: (state, {duration}) ->
    duration?
  did_reset_animation: ->
    no
, default: no

animation_state = switchingReducer
  play_animation: ->
    'playing'
  pause_animation: ->
    'paused'
  reset_animation: ->
    'stopped'
  completed_animation: ->
    'completed'
  set_current_mixin: ->
    'disabled'
  delete_step_arg: ->
    'stopped'
  update_step_arg: ->
    'stopped'
  update_mixin_arg: ->
    'stopped'
  update_step: (state, {duration}) ->
    return state unless duration?

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

_loop = switchingReducer
  update_loop: (state, {loop: _loop}) ->
    _loop
, default: count: 4

animation_steps = switchingReducer
  set_current_mixin: -> [
    changed_args: []
    duration: 400
  ]
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
  toggle_step_preview: (state, {step_index}) ->
    for step, index in state
      if index is step_index
        {preview} = step
        {
          step...
          preview: not preview
        }
      else
        {
          step...
          preview: no
        }
  play_animation: (state) ->
    for step, index in state
      {
        step...
        preview: no
      }
  toggle_animation_step: (state, {step_index}) ->
    for step, index in state
      if index is step_index
        {active} = step
        {
          step...
          active: not (active ? yes)
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
  update_step: (state, {step_index, props...}) ->
    for step, index in state
      if index is step_index
        {
          step...
          props...
        }
      else
        step
  delete_step_arg: (state, {step_index, name}) ->
    for step, index in state
      if index is step_index
        {changed_args} = step
        {
          step...
          changed_args: do ->
            changed_arg for changed_arg in changed_args when changed_arg.name isnt name
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
  reset_animation, loop: _loop
}
