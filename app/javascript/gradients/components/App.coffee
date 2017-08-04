import {Provider, connect} from 'react-redux'
import {css as has} from 'glamor'
import parse_scss from '../helpers/parse_scss'
import random_obj_prop from '../helpers/random_obj_prop'
import MixinEditor from './MixinEditor'
import AnimationEditor from './AnimationEditor'
import SelectMixin from './SelectMixin'
import SaveButton from './SaveButton'
import {set_mixins, set_current_mixin} from '../actions'
import get_current_mixin from '../selectors/get_current_mixin'
import get_mixins from '../selectors/get_mixins'
import get_preview_step_css from '../selectors/get_preview_step_css'
import get_animation_state from '../selectors/get_animation_state'
import isEmpty from 'lodash/isEmpty'
import {Segment, Tab} from 'semantic-ui-react'
{Pane} = Tab
import '../sass/reset.scss'
import '../sass/app.sass'
import 'semantic-ui-css/semantic.min.css'

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

App_ = ({current_mixin, mixins, preview_step_css, animation_state}) ->
  .app
    .preview.(has
      width:  '100%'
      height: '100%'
      # preview_step_css...
    ){ style: preview_step_css unless animation_state in ['playing', 'paused', 'completed']}
      = if current_mixin and not isEmpty mixins
        %Loaded{ current_mixin, mixins }
       else
        .loading
App_ = connect(
  (state) ->
    current_mixin:    get_current_mixin    state
    mixins:           get_mixins           state
    preview_step_css: get_preview_step_css state
    animation_state:  get_animation_state state
) App_

Loaded = ({current_mixin, mixins}) ->
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
    %SaveButton
    %Segment{ vertical: true }
      %SelectMixin{ mixins, current_mixin }
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
            %AnimationEditor{ mixin: current_mixin }
        }
      ]
    }
