import dashed_to_label from '../helpers/dashed_to_label'
import DebouncedInput from './DebouncedInput'
import ColorInput from './ColorInput'
import {css as has} from 'glamor'
import {Message, Form, Icon, Checkbox} from 'semantic-ui-react'
{Field} = Form

export default ({arg: {name, value}, param, onChange, onDelete, auto_open}) ->
  if name is 'background_position'
    %Field
      = %Icon{
        name: 'window close outline'
        link: yes
        fitted: yes
        onClick: onDelete
        style: float: 'right'
      } if onDelete
      %label Background position
        %textarea{
          onChange: ({target: {value: pos}}) ->
            onChange pos
          value
        }
  else
    %Field
      = %Icon{
        name: 'window close outline'
        link: yes
        fitted: yes
        onClick: onDelete
        style: float: 'right'
      } if onDelete
      %label= dashed_to_label name
      = switch param.type
        when 'color'
          %ColorInput{
            onChange
            value
            auto_open
          }
        when 'boolean'
          %Checkbox{
            onChange: (event, {checked}) ->
              onChange checked
            checked: !! value
            toggle: yes
          }
        else
          %DebouncedInput{
            onChange
            value
          }
      %ArgDescription{ param }

ArgDescription = ({param: {description}}) ->
  return null unless description
  %Message.(has
    maxWidth: 300
  ){
    attached: 'bottom'
    info: yes
    size: 'tiny'
  }
    %p= description
