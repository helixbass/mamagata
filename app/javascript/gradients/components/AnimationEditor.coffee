import {connect} from 'react-redux'
import get_mixin_args from '../selectors/get_mixin_args'
import get_animation_state from '../selectors/get_animation_state'
import get_animation_steps from '../selectors/get_animation_steps'
import get_current_mixin from '../selectors/get_current_mixin'
import dashed_to_label from '../helpers/dashed_to_label'
import dashed_to_camel from '../helpers/dashed_to_camel'
import get_sass_and_css from '../helpers/get_sass_and_css'
import extend from '../helpers/extend'
import extended from '../helpers/extended'
import ArgField from './ArgField'
import {Segment, Button, Accordion, Tab, Form, Dropdown} from 'semantic-ui-react'
{TextArea, Field} = Form
import {play_or_pause_animation, add_animation_step, set_animation_step_shorthand, update_step_arg} from '../actions'
import anime from 'animejs'
import 'animate-backgrounds/animate-backgrounds.anime'
import find from 'lodash/find'
import fromPairs from 'lodash/fromPairs'

class AnimationEditor extends React.Component
  constructor: ->
    super()
    @state =
      animation: null
  target_props: ({step}) ->
    {args, current_mixin} = @props
    {changed_args} = step
    {css: start_css} = current_mixin
    parse_css_props = ({css, get_css_dom_vals}) ->
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
      if 'background' of props
        extend props,
          get_css_dom_vals {
            props: ['backgroundImage', 'backgroundPosition']
            parsed: props
            css
          }
        delete props.background
      props
    start_css_props = parse_css_props
      css: start_css
      get_css_dom_vals: ({props}) ->
        el = document.querySelector '.app'
        style = window.getComputedStyle el, null
        fromPairs(
          [prop, style[prop]] for prop in props
        )
    console.log {start_css_props}

    get_sass_and_css {
      mixin: current_mixin
      mixin_args:
        for arg in args
          if changed=find changed_args, name: arg.name
            changed
          else
            arg
    }
    .then ({sass, css}) ->
      # TODO: store sass/css on step?
      step_css_props = parse_css_props {
        css
        get_css_dom_vals: ({props, parsed, css}) ->
          el = document.createElement 'div'
          el.style.visibility = 'hidden'
          document.body.appendChild el
          props_str = do ->
            match = ///
              ^
              \.
              [a-z\-] +
              \s *
              \{
              ([^}] +)
              \}
            ///.exec css
            [all, props_str] = match
            props_str
          el.style.cssText = props_str
          # for prop, val of parsed
          #   el.style[prop] = val
          style = window.getComputedStyle el, null
          ret = fromPairs(
            [prop, style[prop]] for prop in props
          )
          document.body.removeChild el
          ret
      }
      console.log {step_css_props, sass, css}
      fromPairs(
        [name, val] for name, val of step_css_props when start_css_props[name] isnt val
      )

  componentWillReceiveProps: ({animation_state, steps, play_or_pause}) ->
    {animation} = @state
    if animation_state is 'playing' and not animation
      @setState
        animation: do =>
          targets = '.app'
          timeline = anime.timeline
            direction: 'alternate'
            loop: 4
            autoplay: no
            complete: ->
              do play_or_pause
          for step in steps
            props = await @target_props {step}
            console.log {props}
            timeline.add {
              targets
              duration: 1500
              easing: 'linear'
              props...
              # @target_props({step})...
            }
          console.log {timeline}
          do timeline.play
  render: ->
    {mixin, args, animation_state, play_or_pause, add_step} = @props

    .animation-editor
      %Segment{ vertical: yes, textAlign: 'center' }
        %Button{
          icon:
            switch animation_state
              when 'playing' then 'pause'
              else 'play'
          disabled: 'disabled' is animation_state
          active:   'playing'  is animation_state
          onClick: play_or_pause
        }
      %Segment{ vertical: yes }
        %Button{
          icon: 'plus'
          content: 'Add animation step'
          onClick: add_step
        }
        %AnimationSteps
export default AnimationEditor = connect(
  (state) ->
    args: get_mixin_args state
    animation_state: get_animation_state state
    steps: get_animation_steps state
    current_mixin: get_current_mixin state
  (dispatch) ->
    play_or_pause: ->
      dispatch do play_or_pause_animation
    add_step: ->
      dispatch do add_animation_step
) AnimationEditor

AnimationSteps = ({steps}) ->
  %Accordion{
    exclusive: no
    panels:
      for step, step_index in steps
        title: "Step #{step_index + 1}"
        content:
          %AnimationStep{ step, step_index }
        active: yes
  }
AnimationSteps = connect(
  (state) ->
    steps: get_animation_steps state
) AnimationSteps

AnimationStep = ({step, step_index}) ->
  %Tab{
    panes: [
      {
        menuItem: 'Changes'
        render: ->
          %Changes{ step, step_index }
      }
      {
        menuItem: 'Shorthand'
        render: ->
          %Shorthand{ step, step_index }
      }
    ]
  }

class Changes extends React.Component
  # handle_select_param: ({target: {value}}) =>
  handle_select_param: (event, {value}) =>
    {add_animated_param} = @props

    add_animated_param name: value
  render: ->
    {step, step_index, start_args} = @props

    %Form{ size: 'tiny' }
      %Field
        %Dropdown{
          selection: yes
          placeholder: 'Add animated param'
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
