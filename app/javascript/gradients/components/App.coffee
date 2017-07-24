import {Provider, connect} from 'react-redux'
import {css as has} from 'glamor'
import parse_scss from '../helpers/parse_scss'
import random_obj_prop from '../helpers/random_obj_prop'
import MixinEditor from './MixinEditor'
import AnimationEditor from './AnimationEditor'
import SelectMixin from './SelectMixin'
import {set_mixins, set_current_mixin} from '../actions'
import get_current_mixin from '../selectors/get_current_mixin'
import get_mixins from '../selectors/get_mixins'
import isEmpty from 'lodash/isEmpty'
import {Segment} from 'semantic-ui-react'
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

App_ = ({current_mixin, mixins}) ->
  .app
    = if current_mixin and not isEmpty mixins
      %Loaded{ current_mixin, mixins }
     else
      .loading
App_ = connect(
  (state) ->
    current_mixin: get_current_mixin state
    mixins:        get_mixins        state
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
    %Segment{ vertical: true }
      %SelectMixin{ mixins, current_mixin }
    %Segment{ vertical: true }
      %MixinEditor{ mixin: current_mixin }
    %Segment{ vertical: true }
      %AnimationEditor{ mixin: current_mixin }
