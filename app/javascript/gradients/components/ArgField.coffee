import dashed_to_label from '../helpers/dashed_to_label'
import DebouncedInput from './DebouncedInput'
import ColorInput from './ColorInput'
import {Message, Form} from 'semantic-ui-react'
{Field} = Form

export default ({arg: {name, value}, param, onChange}) ->
  %Field
    %label= dashed_to_label name
    = switch param.type
      when 'color'
        %ColorInput{
          onChange
          value
        }
      else
        %DebouncedInput{
          onChange
          value
        }
    %ArgDescription{ param }

ArgDescription = ({param: {description}}) ->
  return null unless description
  %Message{
    attached: 'bottom'
    info: yes
    size: 'tiny'
  }
    %p= description
