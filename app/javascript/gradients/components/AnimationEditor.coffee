import {connect} from 'react-redux'
import {css as has} from 'glamor'
import {contains} from 'underscore.string'
import deep_equal from 'deep-equal'
import get_mixin_args from '../selectors/get_mixin_args'
import get_animation_state from '../selectors/get_animation_state'
import get_animation_steps from '../selectors/get_animation_steps'
import get_current_mixin from '../selectors/get_current_mixin'
import get_loop from '../selectors/get_loop'
import dashed_to_label from '../helpers/dashed_to_label'
import _int from '../helpers/_int'
import extended from '../helpers/extended'
import ArgField from './ArgField'
import {Segment, Button, Accordion, Tab, Form, Checkbox, Dropdown, Input, Icon} from 'semantic-ui-react'
{TextArea, Field} = Form
{Group} = Button
import Collapse from 'react-css-collapse'
import {play_animation, pause_animation, reset_animation, add_animation_step, set_animation_step_shorthand, update_step_arg, delete_step_arg, delete_step, reorder_step, toggle_step_preview, update_step, toggle_animation_step, update_loop as _update_loop} from '../actions'
import find from 'lodash/find'
import fromPairs from 'lodash/fromPairs'
import defer from 'lodash/defer'

AnimationEditor = ({animation_state, play, pause, reset, add_step, animation, handle_seek}) ->
  .animation-editor
    %Controls{ animation_state, play, pause, reset, animation, handle_seek }
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

Controls = ({animation_state, play, pause, reset, animation, handle_seek}) ->
  %Segment{ vertical: yes }
    %div
      %Group
        %ResetButton{ animation_state, reset }
        %PlayButton{ animation_state, play, pause }
      %Progress{ animation, onChange: handle_seek, disabled: 'disabled' is animation_state }
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

class Progress extends React.Component
  constructor: (props) ->
    super props

    @state =
      progress: 0
  componentWillReceiveProps: ({animation}) ->
    {progress = 0} = animation ? {}
    @setState {progress} unless progress is @state.progress
    animation?.update ?= ({progress}) =>
      # #   set_progress {progress}
      defer => @setState {progress}
  render: ->
    {onChange, disabled} = @props
    {progress} = @state

    %input{
      type: 'range'
      value: progress ? 0
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
  %Segment.(has position: 'relative'){ vertical: yes }
    %Button.(has
      position: 'absolute'
      top: 5
      right: 1
      zIndex: 500
    ){
      icon: 'plus'
      size: 'tiny'
      content: 'Add step'
      onClick: add_step
    }
    %AnimationSteps

running_class = has
  backgroundColor: 'rgba(0, 255, 0, 0.3)'
AnimationSteps = ({steps, toggle_step}) ->
  %Accordion{
    exclusive: no
    panels:
      for step, step_index in steps
        {active=yes, running=no} = step
        {
          title:
            %span.(
              has
                transition: 'all .2s'
              "#{running_class}": running
            ) Step {step_index + 1}
          content:
            %Collapse.(has
              transition: 'height 150ms ease-out'
            ){ isOpen: active }
              %AnimationStep{ step, step_index, steps }
          active
          key: "#{step_index}"
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

class AnimationStep extends React.Component
  constructor: (props) ->
    super props

    @state =
      sorting: no
  toggle_sorting: =>
    {sorting} = @state

    @setState sorting: not sorting
  handle_reorder: (event) =>
    {handle_reorder} = @props
    handle_reorder event
    @setState sorting: no
  render: ->
    {step, step_index, set_duration, set_easing, set_elasticity, toggle_preview, handle_delete, steps, set_offset, set_offset_direction} = @props
    {duration, easing, preview, elasticity, offset, offset_from} = step
    {sorting} = @state

    .animation-step
      %Icon{
        name: 'window close outline'
        link: yes
        fitted: yes
        onClick: handle_delete
        style: float: 'right'
      }
      = %Icon{
        name: 'sort'
        link: yes
        fitted: yes
        onClick: @toggle_sorting
        style:
          float: 'right'
          marginRight: 7
      } if steps.length > 1
      %Checkbox{
        label: 'Preview?'
        onChange: toggle_preview
        checked: preview
      }
      = %Sorting{ step_index, steps, @handle_reorder } if sorting
      %StepForm{ set_duration, duration, set_easing, easing, easing_options, set_elasticity, elasticity, offset, offset_from, set_offset, set_offset_direction, step_index }
      %StepTabs{ step, step_index }
AnimationStep = connect(
  null
  (dispatch, {step_index, step}) ->
    set_offset: ({target: {value: offset}}) ->
      dispatch update_step {
        step_index
        offset:
          offset * if step.offset < 0 then -1 else 1
      }
    set_offset_direction: (event, {value: multiplier}) ->
      console.log {offset: step.offset, abs: Math.abs(step.offset), multiplier, _int: _int multiplier}
      dispatch update_step {
        step_index
        offset:
          Math.abs(step.offset) * _int multiplier
      }
    set_duration: ({target: {value: duration}}) ->
      dispatch update_step {step_index, duration}
    set_easing: (event, {value: easing}) ->
      dispatch update_step {step_index, easing}
    set_elasticity: ({target: {value: elasticity}}) ->
      dispatch update_step {step_index, elasticity}
    toggle_preview: ->
      dispatch toggle_step_preview {step_index}
    handle_delete: ->
      return unless window.confirm 'Delete step?'

      dispatch delete_step {step_index}
    handle_reorder: ({target: {value: before_step_index}}) ->
      dispatch reorder_step {step_index, before_step_index}
) AnimationStep

class StepTabs extends React.Component
  shouldComponentUpdate: (nextProps) ->
    {step: {changed_args} = {}} = @props # TODO: this'll have to be updated once other tab has exported JS

    # TODO: use deep equal helper?
    return yes if nextProps.step?.changed_args?.length isnt changed_args?.length
    return no unless changed_args
    for changed_arg, index in changed_args
      next_changed_arg = nextProps.step.changed_args[index]
      return yes if changed_arg.name  isnt next_changed_arg.name
      return yes if changed_arg.value isnt next_changed_arg.value
    no
  render: ->
    {step, step_index} = @props

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

class StepForm extends React.Component
  shouldComponentUpdate: (nextProps) ->
    return yes for prop in ['duration', 'easing', 'elasticity', 'offset'] when @props[prop] isnt nextProps[prop]
    no
  render: ->
    {set_duration, duration, set_easing, easing, easing_options, set_elasticity, elasticity, step_index, offset, offset_from, set_offset, set_offset_direction} = @props

    %Form{ size: 'tiny' }
      %Duration{ duration, set_duration }
      = %StartOffset{ offset, offset_from, set_offset, set_offset_direction } if step_index > 0
      %Easing{ easing, set_easing, easing_options }
      = %Elasticity{ elasticity, set_elasticity } if contains easing, 'Elastic'

Elasticity = ({elasticity, set_elasticity}) ->
  %Field{ inline: yes }
    %label Elasticity
    %Input{
      onChange: set_elasticity
      value: elasticity
      style: width: '70px'
    }

Easing = ({easing, set_easing, easing_options}) ->
  %Field{ inline: yes }
    %label Easing
    %Dropdown.tiny{
      onChange: set_easing
      value: easing
      options: easing_options
      scrolling: yes
      upward: yes
    }

class StartOffset extends React.Component
  constructor: (props) ->
    super props

    @state =
      editing: no
  toggle_editing: =>
    {editing} = @state
    @setState editing: not editing
  render: ->
    {offset, offset_from, set_offset, set_offset_direction} = @props
    {editing} = @state

    %Field{ inline: yes }
      %label Start
      = if editing
        %span
          %Input{
            onChange: set_offset
            value: Math.abs offset
            style: width: '55px'
          }^
          ms
          %Dropdown.tiny.(has
            margin: '0 3px'
          ){
            value:
              if offset < 0
                -1
              else
                1
            options: [
              text: 'before'
              value: -1
            ,
              text: 'after'
              value: 1
            ]
            onChange: set_offset_direction
          }^
          %span
            the previous step ends
        
       else
        %Dropdown.tiny{
          onClick: @toggle_editing
          text:
            "#{
              unless offset
                'when'
              else
                "#{offset}ms #{
                  if offset > 0
                    'after'
                  else
                    'before'
                }"
              } the previous step #{
                  if offset_from is 'prev_end'
                    'ends'
                  else
                    'starts'
                }"
        }

Duration = ({duration, set_duration}) ->
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

Sorting = ({step_index, steps, handle_reorder}) ->
  %select{
    value: ''
    onChange: handle_reorder
  }
    %option{ value: '' } Move to:
    = for step, _step_index in steps when _step_index isnt step_index and _step_index isnt step_index + 1
      %option{ value: _step_index, key: _step_index }
        Before Step {_step_index + 1}
    = unless step_index is steps.length - 1
      %option{ value: 'last' } Last
class Changes extends React.Component
  # handle_select_param: ({target: {value}}) =>
  handle_select_param: (event, {value}) =>
    {add_animated_param} = @props

    add_animated_param name: value
  shouldComponentUpdate: (nextProps) ->
    return yes unless @props.step_index is nextProps.step_index
    return yes unless deep_equal @props.start_args, nextProps.start_args
    return yes unless deep_equal @props.step?.changed_args, nextProps.step?.changed_args
    no

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
            for {name, value, type} in start_args when type isnt 'boolean'
              text: dashed_to_label name
              value: name
          onChange: @handle_select_param
          value: ''
        }
      %ChangedArgs{ step, step_index }
Changes = connect(
  (state) ->
    start_args: do ->
      args = get_mixin_args state
      {params} = get_current_mixin state
      args.map (arg) ->
        {name} = arg

        extended arg,
          type:
            find(
              params
              {name}
            ).type
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
