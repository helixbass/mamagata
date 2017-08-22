import {Button, Modal, Form, Input} from 'semantic-ui-react'
{Header, Content, Actions} = Modal
{Field} = Form
import {save as _save} from '../actions'
import get_saved from '../helpers/get_saved'
import get_working_on_saved from '../selectors/get_working_on_saved'
import BaseComponent from './BaseComponent'
import {connect} from 'react-redux'
import {css as has} from 'glamor'
import find from 'lodash/find'

class SaveButton extends BaseComponent
  stateChangeHandlers: 'name'
  componentWillReceiveProps: ({working_on_saved}) ->
    if working_on_saved isnt @props.working_on_saved
      @setState name: working_on_saved

  handle_open: =>
    @setState modal_open: yes
  handle_close: =>
    @setState modal_open: no
  handle_save: =>
    {save} = @props
    {name} = @state

    save {name}

    do @handle_close
  render: ->
    {saved} = @props
    {name, modal_open} = @state

    %Modal{
      open: modal_open
      onClose: @handle_close
      trigger:
        %Button.(has
          paddingLeft: '1.3em !important'
          paddingRight: '1.3em !important'
        ){
          icon: 'save'
          content: 'Save'
          onClick: @handle_open
          size: 'tiny'
        }
    }
      %Header{
        icon: 'save'
        content: 'Save'
      }
      %Content
        %p Save to your browser's localStorage
        %Form
          %Field
            %label Save as:
            %input{
              type: 'text'
              value: name ? ''
              onChange: @handleNameChange
            }
      %Actions
        %Button{
          onClick: @handle_save
          disabled: not name
        }
          = if find saved, {name}
            "Overwrite '#{name}'"
           else
            'Save'
export default connect(
  (state) ->
    saved: do get_saved
    working_on_saved: get_working_on_saved state
  (dispatch) ->
    save: ({name}) ->
      dispatch _save {name}
) SaveButton
