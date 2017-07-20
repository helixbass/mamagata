import {connect} from 'react-redux'
import {css as has} from 'glamor'
import get_mixin_args from '../selectors/get_mixin_args'
import dashed_to_label from '../helpers/dashed_to_label'
import find from 'lodash/find'
import DebouncedInput from './DebouncedInput'
import ColorInput from './ColorInput'
import {Form, Message, Tab} from 'semantic-ui-react'
import {update_mixin_arg} from '../actions'
{Field} = Form
{Pane} = Tab

class MixinEditor extends React.Component
  render: ->
    {mixin, args} = @props

    %Tab{
      panes: [
        {
          menuItem:
            icon: 'edit'
            content: 'Edit'
            key: 'edit'
          render: ->
            %Pane
              %MixinParams{ mixin, args }
        }
        {
          menuItem: 'SCSS'
          render: ->
            %Pane
              %MixinSass{ mixin }
        }
        {
          menuItem: 'CSS'
          render: ->
            %Pane
              %MixinCSS{ mixin }
        }
      ]
    }
export default MixinEditor = connect(
  (state) ->
    args: get_mixin_args state
) MixinEditor

MixinParams = ({mixin, args}) ->
  %Form{ size: 'tiny' }
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

    %div
      %Field
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
  %Message{
    attached: 'bottom'
    info: yes
    size: 'tiny'
  }
    %p= description

MixinCSS = ({mixin: {css}}) ->
  %pre.(has
    whiteSpace: 'pre-wrap'
  )
    = css.replace /\.app /, '.selector '

MixinSass = ({mixin: {sass}}) ->
  %pre.(has
    whiteSpace: 'pre-wrap'
  )
    = sass.replace /\.app /, '.selector '
