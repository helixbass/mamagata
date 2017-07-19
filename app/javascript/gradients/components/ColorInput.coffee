import {css as has} from 'glamor'
import {PhotoshopPicker} from 'react-color'
import css_color_names from '../helpers/css_color_names'
import $ from 'jquery'
import 'jquery-color'
# import 'jquery-color/jquery.color.svg-names'
{Color, extend} = $
extend Color.names, css_color_names

rgba_obj_from_color_str = (str) ->
  [r, g, b, a] = Color(str).rgba()
  console.log {r, g, b, a, str}
  {r, g, b, a}

export default class ColorInput extends React.Component
  constructor: ({value}) ->
    super()
    @state =
      color: rgba_obj_from_color_str value
      editing: no
  handle_change_complete: (color) =>
    {onChange} = @props

    onChange color.hex

    @setState {color}
  toggle_editing: =>
    {editing} = @state

    @setState editing: not editing
  render: ->
    {onChange, value} = @props
    {color, editing} = @state

    if editing
      %PhotoshopPicker{
        color
        onChangeComplete: @handle_change_complete
        onClose: @toggle_editing
      }
    else
      %ColorButton{ color, value, onClick: @toggle_editing }

ColorButton = ({color, value, onClick}) ->
  {r, g, b, a} = color.rgb ? color

  .(has
    padding: 5
    background: 'white'
    borderRadius: 1
    boxShadow: '0 0 0 1px rgba(0, 0, 0, .1)'
    display: 'inline-block'
    cursor: 'pointer'
  ){ onClick }
    .(has
      width: 36
      height: 14
      borderRadius: 2
      backgroundColor:
        "rgba(#{r}, #{g}, #{b}, #{a})"
      border: '1px solid #777'
    )
    %span
      = value
