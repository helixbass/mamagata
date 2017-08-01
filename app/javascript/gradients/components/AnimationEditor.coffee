import {connect} from 'react-redux'
import {css as has} from 'glamor'
import {contains} from 'underscore.string'
import get_mixin_args from '../selectors/get_mixin_args'
import get_animation_state from '../selectors/get_animation_state'
# import get_animation_progress from '../selectors/get_animation_progress'
import get_animation_seek from '../selectors/get_animation_seek'
import get_animation_steps from '../selectors/get_animation_steps'
import get_current_mixin from '../selectors/get_current_mixin'
import get_reset_animation from '../selectors/get_reset_animation'
import get_loop from '../selectors/get_loop'
import dashed_to_label from '../helpers/dashed_to_label'
import get_sass_and_css from '../helpers/get_sass_and_css'
import parse_css_props from '../helpers/parse_css_props'
import extend from '../helpers/extend'
import extended from '../helpers/extended'
import ArgField from './ArgField'
import {Segment, Button, Accordion, Tab, Form, Checkbox, Dropdown, Input} from 'semantic-ui-react'
{TextArea, Field} = Form
{Pane} = Tab
{Group} = Button
import {play_animation, pause_animation, reset_animation, completed_animation, did_reset_animation as _did_reset_animation, seek_animation, sought_animation, add_animation_step, set_animation_step_shorthand, update_step_arg, delete_step_arg, toggle_step_preview, update_step, toggle_animation_step, update_loop as _update_loop} from '../actions'
import anime from 'animejs'
import 'animate-backgrounds/animate-backgrounds.anime'
import find from 'lodash/find'
import fromPairs from 'lodash/fromPairs'

class AnimationEditor extends React.Component
  constructor: ->
    super()
    @state =
      animation: null
  prev_arg: ({arg, step_index, steps}) ->
    {name} = arg
    for {changed_args} in steps[...step_index] by -1
      return last_changed if last_changed=find changed_args, {name}
    arg
  target_props: ({step, prev_step, step_index, steps, _update_step}) ->
    {args, current_mixin} = @props
    {changed_args} = step
    start_css =
      prev_step?.css ? current_mixin.css
    start_css_props =
      parse_css_props
        css: start_css
    get_sass_and_css {
      mixin: current_mixin
      mixin_args:
        for arg in args
          if changed=find changed_args, name: arg.name
            changed
          else
            @prev_arg {arg, step_index, steps}
    }
    .then ({sass, css}) ->
      _update_step {step_index, sass, css}
      step_css_props =
        parse_css_props {css}
      fromPairs(
        [name, val] for name, val of step_css_props when start_css_props[name] isnt val
      )
  create_animation: ({steps, completed, _update_step, loop: _loop}) ->
    targets = '.app'
    timeline = anime.timeline
      direction: 'alternate' if _loop
      loop: _loop?.count * 2
      autoplay: no
      complete: ->
        do completed
      update: ({progress}) =>
      #   set_progress {progress}
        @setState {progress}
    prev_step = null
    for step, step_index in steps
      {duration, easing, elasticity} = step
      props = await @target_props {step, prev_step, step_index, steps, _update_step}
      timeline.add {
        targets, duration, easing, elasticity
        props...
        # @target_props({step})...
      }
      prev_step = step
    console.log {timeline}
    @setState
      animation: timeline
      progress: 0

  componentWillReceiveProps: ({animation_state, animation_seek, sought, steps, completed, _update_step, reset_animation, did_reset_animation, loop: _loop}) ->
    {animation} = @state
    {animation_state: old_state} = @props

    if animation_seek
      animation?.seek animation_seek
      do sought

    switch animation_state
      when 'playing'
        switch old_state
          when 'completed'
            animation?.restart()
          when 'paused', 'stopped'
            animation?.play()
      when 'paused'
        if old_state is 'playing'
          animation?.pause()
      when 'stopped', 'disabled'
        animation?.pause()
        animation?.seek 0

    if reset_animation
      document.querySelector '.app'
      .style.cssText = ''

      @setState(animation: null, progress: 0) if animation
      @create_animation {steps, completed, _update_step, loop: _loop}
      # set_progress progress: 0
      do did_reset_animation
  handle_seek: ({target: {value}}) =>
    {seek} = @props
    {animation} = @state
    return unless animation
    {duration} = animation

    seek time: duration * value / 100
  render: ->
    {mixin, args, animation_state, play, pause, reset, add_step} = @props
    {progress} = @state

    .animation-editor
      %Controls{ animation_state, play, pause, reset, progress, @handle_seek }
      %Steps{ add_step }
export default AnimationEditor = connect(
  (state) ->
    args: get_mixin_args state
    animation_state: get_animation_state state
    animation_seek: get_animation_seek state
    # animation_progress: get_animation_progress state
    steps: get_animation_steps state
    loop: get_loop state
    current_mixin: get_current_mixin state
    reset_animation: get_reset_animation state
  (dispatch) ->
    play: ->
      dispatch do play_animation
    pause: ->
      dispatch do pause_animation
    reset: ->
      dispatch do reset_animation
    did_reset_animation: ->
      dispatch do _did_reset_animation
    completed: ->
      dispatch do completed_animation
    # set_progress: ({progress}) ->
    #   dispatch set_animation_progress {progress}
    _update_step: ({step_index, props...}) ->
      dispatch update_step {step_index, props...}
    seek: ({time}) ->
      dispatch seek_animation {time}
    sought: ->
      dispatch do sought_animation
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
      content: 'Add animation step'
      onClick: add_step
    }
    %AnimationSteps

AnimationSteps = ({steps, toggle_step}) ->
  %Accordion{
    exclusive: no
    panels:
      for step, step_index in steps
        {active} = step
        title: "Step #{step_index + 1}"
        content:
          %AnimationStep{ step, step_index }
        active: active ? yes
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
            %Pane
              %Changes{ step, step_index }
        }
        {
          menuItem: 'Shorthand'
          render: ->
            %Pane
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
