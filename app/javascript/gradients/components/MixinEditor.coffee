import {connect} from 'react-redux'
import get_mixin_args from '../selectors/get_mixin_args'
import dashed_to_label from '../helpers/dashed_to_label'
import find from 'lodash/find'
import DebouncedInput from './DebouncedInput'
import ColorInput from './ColorInput'
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

class MixinParam extends React.Component
  handle_change: (value) =>
    {update_value} = @props
    update_value value
  render: ->
    {arg: {name, value}, param} = @props

    .mixin-param
      %label= dashed_to_label name
      = switch param.type
        when 'color'
          %ColorInput{
            onChange: @handle_change
            value
          }
        else
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
