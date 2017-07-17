import {connect} from 'react-redux'
import get_mixin_args from '../selectors/get_mixin_args'
import find from 'lodash/find'
import DebouncedInput from './DebouncedInput'
import {capitalize} from 'underscore.string'
import {update_mixin_arg} from '../actions'

class MixinEditor extends React.Component
  render: ->
    {mixin, args} = @props

    .mixin-editor
      %MixinParams{ mixin, args }
export default MixinEditor = connect(
  (state) ->
    args: get_mixin_args state
) MixinEditor

MixinParams = ({mixin, args}) ->
  .mixin-params
    = %MixinParam{
      param, mixin
      arg: find args, name: param.name
      key: param.name
    } for param in mixin.params

dashed_to_label = (str) ->
  capitalize str.replace /-([a-z])/, ' $1'

class MixinParam extends React.Component
  handle_change: (value) =>
    {update_value} = @props
    update_value value
  render: ->
    {arg: {name, value}, param} = @props

    .mixin-param
      %label= dashed_to_label name
      %DebouncedInput{
        onChange: @handle_change
        value
      }
      %MixinParamDescription{ param }
MixinParam = connect(
  null
  (dispatch, props) ->
    update_value: (value) ->
      {mixin, param: {name}} = props
      dispatch update_mixin_arg {mixin, name, value}
) MixinParam

MixinParamDescription = ({param: {description}}) ->
  return null unless description
  %p= description
