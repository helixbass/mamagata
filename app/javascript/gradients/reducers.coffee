import {combineReducers} from 'redux'
import switchingReducer from './helpers/switchingReducer'
import find from 'lodash/find'

mixin_args = switchingReducer
  load_saved: (state, {saved: {mixin_args}}) ->
    mixin_args
  set_current_mixin: (state, {mixin: {params}}) ->
    for {name, default: _default} in params
      {
        name
        value: _default
      }

  update_mixin_arg: (state, {name, value}) ->
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
  # update_mixin_arg: ->
  update_current_mixin: ->
    yes
  update_step: (state, {duration, easing, elasticity}) ->
    duration? or easing? or elasticity?
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
  load_saved: ->
    'stopped'
  delete_step_arg: ->
    'stopped'
  update_step_arg: ->
    'stopped'
  update_mixin_arg: ->
    'stopped'
  update_step: (state, {duration, easing, elasticity}) ->
    return state unless duration? or easing? or elasticity?

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
  load_saved: (state, {saved: {loop: _loop}}) ->
    _loop
  update_loop: (state, {loop: _loop}) ->
    _loop
, default: count: 4

default_step_props =
  changed_args: []
  duration: 400
  easing: 'linear'
  elasticity: 500
animation_steps = switchingReducer
  load_saved: (state, {saved: {animation_steps}}) ->
    animation_steps
  set_current_mixin: -> [
    default_step_props
  ]
  add_animation_step: (state) -> [
    (for step in state
      {
        step...
        active: no
      }
    )...
    default_step_props
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

working_on_saved = switchingReducer
  set_current_mixin: ->
    null
  load_saved: (state, {saved: {name}}) ->
    name
  save: (state, {name}) ->
    name

export default combineReducers {
  mixin_args, mixins, current_mixin
  animation_steps, animation_state
  animation_progress, animation_seek
  reset_animation, loop: _loop
  working_on_saved
}
