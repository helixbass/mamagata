import {connect} from 'react-redux'
import {css as has} from 'glamor'
import get_mixin_args from '../selectors/get_mixin_args'
import find from 'lodash/find'
import ArgField from './ArgField'
import {Form, Tab} from 'semantic-ui-react'
import {update_mixin_arg} from '../actions'
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

MixinParam = connect(
  null
  (dispatch, props) ->
    onChange: (value) ->
      {mixin, param: {name}} = props

      dispatch update_mixin_arg {mixin, name, value}
) ArgField

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
