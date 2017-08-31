import {Provider, connect} from 'react-redux'
import {css as has} from 'glamor'
import parse_scss from '../helpers/parse_scss'
import random_obj_prop from '../helpers/random_obj_prop'
import Loading from './Loading'
import MixinEditor from './MixinEditor'
import AnimationEditor from './AnimationEditor'
import SelectMixin from './SelectMixin'
import SaveButton from './SaveButton'
import HelpButton from './HelpButton'
import LoadSaved from './LoadSaved'
import {set_mixins, set_current_mixin, completed_animation, did_reset_animation as _did_reset_animation, set_animation_js, seek_animation, sought_animation, update_step} from '../actions'
import get_current_mixin from '../selectors/get_current_mixin'
import get_mixins from '../selectors/get_mixins'
import get_preview_step_css from '../selectors/get_preview_step_css'
import get_animation_state from '../selectors/get_animation_state'
import get_animation_steps from '../selectors/get_animation_steps'
# import get_animation_progress from '../selectors/get_animation_progress'
import get_animation_seek from '../selectors/get_animation_seek'
import get_mixin_args from '../selectors/get_mixin_args'
import get_reset_animation from '../selectors/get_reset_animation'
import get_loop from '../selectors/get_loop'
import get_sass_and_css from '../helpers/get_sass_and_css'
import parse_css_props from '../helpers/parse_css_props'
import extend from '../helpers/extend'
import extended from '../helpers/extended'
import {contains} from 'underscore.string'
import isEmpty from 'lodash/isEmpty'
import mapValues from 'lodash/mapValues'
import {Segment, Tab, Message, Icon} from 'semantic-ui-react'
import anime from 'animejs-hooks'
import 'animate-backgrounds/animate-backgrounds.anime'
import find from 'lodash/find'
import fromPairs from 'lodash/fromPairs'
import '../sass/reset.scss'
import 'semantic-ui-css/semantic.min.css'
import '../sass/app.sass'
import '../sass/loader.css'
import Perf from 'react-addons-perf'
window.Perf = Perf

export default class App extends React.Component
  componentDidMount: ->
    {store} = @props
    {dispatch} = store

    parse_scss()
    .then ({mixins}) =>
      dispatch set_mixins {mixins}
      dispatch set_current_mixin random_obj_prop mixins

  render: ->
    {store} = @props

    %Provider{ store }
      %App_

class App_ extends React.Component
  constructor: ->
    super()
    @state =
      animation: null
      loading: no
  prev_arg: ({arg, step_index, steps}) ->
    {name} = arg
    for {changed_args} in steps[...step_index] by -1
      return last_changed if last_changed=find changed_args, {name}
    arg
  target_props: ({step, prev_step, step_index, steps, _update_step, current_mixin}) ->
    {args} = @props
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
      extend step, {sass, css}
      step_css_props =
        parse_css_props {css}
      fromPairs([
        ([name, val] for name, val of step_css_props when start_css_props[name] isnt val)...
        (if background_position_arg=find changed_args, name: 'background_position'
          [[
            'backgroundPosition'
            background_position_arg.value
          ]]
        else [])...
      ])
  create_animation: ({steps, completed, _update_step, _set_animation_js, loop: _loop, current_mixin}) ->
    targets = '.app'
    timeline = anime.timeline
      direction: 'alternate' if _loop
      loop: _loop?.count * 2
      autoplay: no
      complete: ->
        do completed
    js = """
      anime
      .timeline({#{
        if _loop
          """
          \n  direction: 'alternate',
            loop: #{_loop.count * 2},
          """
        else '' }
      })
    """
    prev_step = null
    add_simultaneous = do ->
      simultaneous = steps.some ({offset}) -> offset < 0
      (props) ->
        return props unless simultaneous
        mapValues props, (val, prop_name) ->
          return val unless prop_name is 'backgroundImage'
          "simultaneous #{val}"
    for step, step_index in steps
      {duration, easing, elasticity, offset} = step
      props = add_simultaneous await @target_props {step, prev_step, step_index, steps, _update_step, current_mixin}
      offset_str =
        "#{if offset < 0 then '-' else '+'}=#{Math.abs offset}" if offset
      timeline.add {
        targets, duration, easing, elasticity
        offset: offset_str
        seekIgnoreOffset: yes
        # begin: do (step_index) -> ->
        #   _update_step {step_index, running: yes}
        # complete: do (step_index) -> ->
        #   _update_step {step_index, running: no}
        props...
        # @target_props({step})...
      }
      js += """
      \n.add({
        targets: '.SELECTOR',#{
          if offset
            """
            \n  offset: '#{offset_str}',
            """
          else ''
        }
        duration: #{duration},
        easing: '#{easing}',#{
          if contains easing, 'Elastic'
            "\n  elasticity: #{elasticity},"
          else '' }
        seekIgnoreOffset: true,#{
          (for prop_name, prop_val of props
            """
            \n  #{prop_name}: '#{prop_val}',
            """).join '' }
      })
      """
      prev_step = step
    console.log {timeline}
    _set_animation_js {js}
    @setState
      animation: timeline
      progress: 0
      loading: no

  componentWillReceiveProps: ({animation_state, animation_seek, sought, steps, completed, _update_step, _set_animation_js, reset_animation, did_reset_animation, loop: _loop, current_mixin}) ->
    {animation_state: old_state} = @props
    {animation} = @state

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

      @setState(animation: null, progress: 0, loading: yes) if animation
      @create_animation {steps, completed, _update_step, _set_animation_js, loop: _loop, current_mixin} if current_mixin?.css
      # set_progress progress: 0
      do did_reset_animation
  handle_seek: ({target: {value}}) =>
    {seek} = @props
    {animation} = @state
    return unless animation
    {duration} = animation

    seek time: duration * value / 100
  render: ->
    {current_mixin, mixins, preview_step_css, animation_state} = @props
    {animation, loading} = @state

    .app
      .preview.(has
        width:  '100%'
        height: '100%'
        # preview_step_css...
      ){ style: preview_step_css unless animation_state in ['playing', 'paused', 'completed']}
        = if current_mixin and not isEmpty mixins
          %Loaded{ current_mixin, mixins, @handle_seek, animation }
         else
          %Loading
        = %Loading if loading
App_ = connect(
  (state) ->
    current_mixin:    get_current_mixin    state
    mixins:           get_mixins           state
    preview_step_css: get_preview_step_css state
    animation_state:  get_animation_state state
    args: get_mixin_args state
    animation_seek: get_animation_seek state
    # animation_progress: get_animation_progress state
    steps: get_animation_steps state
    loop: get_loop state
    current_mixin: get_current_mixin state
    reset_animation: get_reset_animation state
  (dispatch) ->
    did_reset_animation: ->
      dispatch do _did_reset_animation
    completed: ->
      dispatch do completed_animation
    # set_progress: ({progress}) ->
    #   dispatch set_animation_progress {progress}
    _update_step: ({step_index, props...}) ->
      dispatch update_step {step_index, props...}
    _set_animation_js: ({js}) ->
      dispatch set_animation_js {js}
    seek: ({time}) ->
      dispatch seek_animation {time}
    sought: ->
      dispatch do sought_animation
) App_

Loaded = ({current_mixin, mixins, handle_seek, animation}) ->
  .loaded.(has
    position: 'absolute'
    right: 10
    top: 15
    backgroundColor: 'rgba(245, 245, 245, 0.91)'
    padding: '20px 15px'
    borderRadius: 5
    maxWidth: 600
    maxHeight: '90%'
    overflowY: 'auto'
  )
    %HelpButton
    %SaveButton
    %LoadSaved
    %Segment{ vertical: true }
      %SelectMixin{ mixins, current_mixin }
      %MixinSource{ current_mixin }
    %Tab{
      menu:
        secondary: yes
        pointing: yes
        style: marginBottom: '.5rem'
      panes: [
        {
          menuItem:
            key: 'customize'
            icon: 'configure'
            content: 'Customize'
          render: ->
            %MixinEditor{ mixin: current_mixin }
        }
        {
          menuItem:
            key: 'animate'
            icon: 'video play'
            content: 'Animate'
          render: ->
            %AnimationEditor{ mixin: current_mixin, handle_seek, animation }
        }
      ]
    }

MixinSource = ({current_mixin: {source_url}}) ->
  return null unless source_url

  .(has
    fontSize: '.8em'
    marginBottom: '-1em'
  )
    %span.(has color: '#888')
      Source:
    %a{ href: source_url }^
      = source_url
        .replace /// ^ https?:// ///, ''
