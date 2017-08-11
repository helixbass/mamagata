import {connect} from 'react-redux'
import {css as has} from 'glamor'
import {contains} from 'underscore.string'
import get_mixin_args from '../selectors/get_mixin_args'
import get_animation_state from '../selectors/get_animation_state'
import get_animation_steps from '../selectors/get_animation_steps'
import get_current_mixin from '../selectors/get_current_mixin'
import get_loop from '../selectors/get_loop'
import dashed_to_label from '../helpers/dashed_to_label'
import ArgField from './ArgField'
import {Segment, Button, Accordion, Tab, Form, Checkbox, Dropdown, Input} from 'semantic-ui-react'
{TextArea, Field} = Form
{Group} = Button
import Collapse from 'react-css-collapse'
import {play_animation, pause_animation, reset_animation, add_animation_step, set_animation_step_shorthand, update_step_arg, delete_step_arg, toggle_step_preview, update_step, toggle_animation_step, update_loop as _update_loop} from '../actions'
import find from 'lodash/find'
import fromPairs from 'lodash/fromPairs'

AnimationEditor = ({animation_state, play, pause, reset, add_step, progress, handle_seek}) ->
  .animation-editor
    %Controls{ animation_state, play, pause, reset, progress, handle_seek }
    %Steps{ add_step }
export default AnimationEditor = connect(
  (state) ->
    animation_state: get_animation_state state
  (dispatch) ->
    play: ->
      dispatch do play_animation
    pause: ->
      dispatch do pause_animation
    reset: ->
      dispatch do reset_animation
    add_step: ->
      dispatch do add_animation_step
) AnimationEditor

Controls = ({animation_state, play, pause, reset, progress, handle_seek}) ->
  %Segment{ vertical: yes }
    %div
      %Group
        %ResetButton{ animation_state, reset }
        %PlayButton{ animation_state, play, pause }
      %Progress{ animation_progress: progress, onChange: handle_seek, disabled: 'disabled' is animation_state }
    %LoopControl

LoopControl = ({update_loop, _loop}) ->
  .(has marginLeft: 10, marginTop: 2)
    %Checkbox{
      label: 'Loop?'
      onChange: ->
        update_loop
          loop: not _loop
          count: 4
      checked: !! _loop
    }
    = if _loop
      {count} = _loop
      %Input.(has
        width: 40
        marginLeft: 5
      ){
        label:
          basic: yes
          content: 'x'
        labelPosition: 'right'
        value: count
        onChange: ({target: {value: count}}) ->
          update_loop {
            loop: yes
            count
          }
      }
LoopControl = connect(
  (state) ->
    _loop: get_loop state
  (dispatch) ->
    update_loop: ({loop: _loop, count}) ->
      dispatch _update_loop(
        loop:
          if _loop
            {count}
          else off
      )
) LoopControl

Progress = ({animation_progress, onChange, disabled}) ->
  %input{
    type: 'range'
    value: animation_progress ? 0
    onChange, disabled
  }

ResetButton = ({animation_state, reset}) ->
  %Button{
    icon: 'step backward'
    disabled: 'disabled' is animation_state
    onClick: reset
  }

PlayButton = ({animation_state, play, pause}) ->
  %Button{
    style: marginRight: 5
    icon:
      switch animation_state
        when 'playing' then 'pause'
        else 'play'
    disabled: 'disabled' is animation_state
    active:   'playing'  is animation_state
    onClick:
      switch animation_state
        when 'playing' then pause
        else play
  }

Steps = ({add_step}) ->
  %Segment{ vertical: yes }
    %Button{
      icon: 'plus'
      size: 'tiny'
      content: 'Add step'
      onClick: add_step
    }
    %AnimationSteps

AnimationSteps = ({steps, toggle_step}) ->
  %Accordion{
    exclusive: no
    panels:
      for step, step_index in steps
        {active=yes} = step
        {
          title: "Step #{step_index + 1}"
          content:
            %Collapse.(has
              transition: 'height 150ms ease-out'
            ){ isOpen: active }
              %AnimationStep{ step, step_index }
          active
        }
    onTitleClick: (event, step_index) ->
      toggle_step {step_index}
  }
AnimationSteps = connect(
  (state) ->
    steps: get_animation_steps state
  (dispatch) ->
    toggle_step: ({step_index}) ->
      dispatch toggle_animation_step {step_index}
) AnimationSteps

easing_options = [
  'linear'
  'easeInQuad'
  'easeInCubic'
  'easeInQuart'
  'easeInQuint'
  'easeInSine'
  'easeInExpo'
  'easeInCirc'
  'easeInBack'
  'easeInElastic'
  'easeOutQuad'
  'easeOutCubic'
  'easeOutQuart'
  'easeOutQuint'
  'easeOutSine'
  'easeOutExpo'
  'easeOutCirc'
  'easeOutBack'
  'easeOutElastic'
  'easeInOutQuad'
  'easeInOutCubic'
  'easeInOutQuart'
  'easeInOutQuint'
  'easeInOutSine'
  'easeInOutExpo'
  'easeInOutCirc'
  'easeInOutBack'
  'easeInOutElastic'
].map (easing) ->
  key: easing
  value: easing
  text: easing

AnimationStep = ({step, step_index, set_duration, set_easing, set_elasticity, toggle_preview}) ->
  {duration, easing, preview, elasticity} = step

  .animation-step
    %Checkbox{
      label: 'Preview?'
      onChange: -> toggle_preview {step_index}
      checked: preview
    }
    %Form{ size: 'tiny' }
      %Field{ inline: yes }
        %label Duration
        %Input{
          label:
            basic: yes
            content: 'ms'
          labelPosition: 'right'
          onChange: set_duration
          value: duration
          style: width: '70px'
        }
      %Field{ inline: yes }
        %label Easing
        %Dropdown.tiny{
          onChange: set_easing
          value: easing
          options: easing_options
        }
      = if contains easing, 'Elastic'
        %Field{ inline: yes }
          %label Elasticity
          %Input{
            onChange: set_elasticity
            value: elasticity
            style: width: '70px'
          }
    %Tab{
      panes: [
        {
          menuItem: 'Changes'
          render: ->
            %Tab.Pane
              %Changes{ step, step_index }
        }
        {
          menuItem: 'Shorthand'
          render: ->
            %Tab.Pane
              %Shorthand{ step, step_index }
        }
      ]
    }
AnimationStep = connect(
  null
  (dispatch, {step_index}) ->
    set_duration: ({target: {value: duration}}) ->
      dispatch update_step {step_index, duration}
    set_easing: (event, {value: easing}) ->
      dispatch update_step {step_index, easing}
    set_elasticity: ({target: {value: elasticity}}) ->
      dispatch update_step {step_index, elasticity}
    toggle_preview: ({step_index}) ->
      dispatch toggle_step_preview {step_index}
) AnimationStep

class Changes extends React.Component
  # handle_select_param: ({target: {value}}) =>
  handle_select_param: (event, {value}) =>
    {add_animated_param} = @props

    add_animated_param name: value
  render: ->
    {step, step_index, start_args} = @props

    %Form{ size: 'tiny' }
      %Field
        %Dropdown.icon.tiny{
          button: yes
          labeled: yes
          scrolling: yes
          upward: yes
          icon: 'plus'
          text: 'Add animated param'
          options:
            for {name, value} in start_args
              text: dashed_to_label name
              value: name
          onChange: @handle_select_param
          value: ''
        }
      %ChangedArgs{ step, step_index }
Changes = connect(
  (state) ->
    start_args: get_mixin_args state
  (dispatch, {step_index}) ->
    add_animated_param: ({name}) ->
      dispatch update_step_arg {step_index, name}
) Changes

ChangedArgs = ({step: {changed_args}, step_index}) ->
  .changed_args
    = %ChangedArg{ arg, step_index, key: arg.name } for arg in changed_args

ChangedArg = connect(
  (state, {arg: {name}}) ->
    param:
      find(
        get_current_mixin(state).params
        {name}
      )
  (dispatch, {step_index, arg: {name}}) ->
    onChange: (value) ->
      dispatch update_step_arg {step_index, name, value}
    onDelete: ->
      # return unless window.confirm 'Remove ?'
      dispatch delete_step_arg {step_index, name}
) ArgField

Shorthand = ({step, step_index, set_shorthand}) ->
  %Form
    %TextArea{
      rows: 8
      onChange: ({target: {value}}) ->
        set_shorthand value
    }
Shorthand = connect(
  null
  (dispatch, {step_index}) ->
    set_shorthand: (shorthand) ->
      dispatch set_animation_step_shorthand {
        shorthand, step_index
      }
) Shorthand
