import {connect} from 'react-redux'
import get_mixin_args from '../selectors/get_mixin_args'
import get_animation_state from '../selectors/get_animation_state'
import get_animation_steps from '../selectors/get_animation_steps'
import {Segment, Button, Accordion, Tab, Form} from 'semantic-ui-react'
{TextArea} = Form
import {play_or_pause_animation, add_animation_step, set_animation_step_shorthand} from '../actions'
import Anime from 'animejs'
import 'animate-backgrounds/animate-backgrounds.anime'

class AnimationEditor extends React.Component
  constructor: ->
    super()
    @state =
      animation: null
  componentWillReceiveProps: ({animation_state, steps}) ->
    {animation} = @state
    if animation_state is 'playing' and not animation
      @setState
        animation:
          new Anime
            duration: 1000
            targets: '.app'
            backgroundImage: steps[0].shorthand
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
        menuItem: 'Shorthand'
        render: ->
          %Shorthand{ step, step_index }
      }
    ]
  }

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
