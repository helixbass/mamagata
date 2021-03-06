import {combineReducers} from 'redux'
import switchingReducer from './helpers/switchingReducer'
import _int from './helpers/_int'
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
  delete_step: ->
    yes
  reorder_step: ->
    yes
  delete_step_arg: ->
    yes
  update_step_arg: ->
    yes
  # update_mixin_arg: ->
  update_current_mixin: ->
    yes
  update_step: (state, {duration, easing, elasticity, offset}) ->
    duration? or easing? or elasticity? or offset?
  reset_animation: ->
    yes
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
  delete_step: ->
    'stopped'
  reorder_step: ->
    'stopped'
  delete_step_arg: ->
    'stopped'
  update_step_arg: ->
    'stopped'
  update_mixin_arg: ->
    'stopped'
  update_step: (state, {duration, easing, elasticity, offset}) ->
    return state unless duration? or easing? or elasticity? or offset?

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

animation_js = switchingReducer
  set_animation_js: (state, {js}) ->
    js
, default: ''

default_step_props =
  changed_args: []
  duration: 400
  easing: 'linear'
  elasticity: 500
  offset: 0
  offset_from: 'prev_end'
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
  delete_step: (state, {step_index}) ->
    step for step, _step_index in state when step_index isnt _step_index
  reorder_step: (state, {step_index, before_step_index}) ->
    step = state[step_index]
    return [
      (_step for _step, _step_index in state when step_index isnt _step_index)...
      step
    ] if before_step_index is 'last'
    steps = []
    before_step_index = _int before_step_index
    for _step, _step_index in state when _step_index isnt step_index
      steps.push step if _step_index is before_step_index
      steps.push _step
    steps
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

preset_colors = switchingReducer
  add_preset_color: (state, {color}) ->
    [
      color
      state...
    ][...16]
, default: [
  '#d0021b', '#f5a623', '#f8e71c', '#8b572a', '#7ed321', '#417505', '#bd10e0', '#9013fe'
  '#4a90e2', '#50e3c2', '#b8e986', '#000000', '#4a4a4a', '#9b9b9b', '#ffffff'
]

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
  animation_js
  reset_animation, loop: _loop
  working_on_saved
  preset_colors
}
