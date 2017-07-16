import {Provider, connect} from 'react-redux'
import {css as has} from 'glamor'
import parse_scss from '../helpers/parse_scss'
import MixinEditor from './MixinEditor'
import {set_mixins, set_current_mixin} from '../actions'
import get_current_mixin from '../selectors/get_current_mixin'
import '../sass/app.sass'

export default class App extends React.Component
  componentDidMount: ->
    {store} = @props
    {dispatch} = store

    parse_scss()
    .then ({mixins}) =>
      dispatch set_mixins {mixins}
      dispatch set_current_mixin mixins.marrakesh

  render: ->
    {store} = @props

    %Provider{ store }
      %App_

App_ = ({current_mixin}) ->
  # .app.(has width: '100%', height: 800)
  .app
    = if current_mixin
      %MixinEditor{ mixin: current_mixin }
     else
      .loading
App_ = connect(
  (state) ->
    current_mixin: get_current_mixin state
) App_
