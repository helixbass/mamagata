import {css as has} from 'glamor'
import {PhotoshopPicker} from 'react-color'
import css_color_names from '../helpers/css_color_names'
import $ from 'jquery'
import 'jquery-color'
import {Menu, Label, Dropdown} from 'semantic-ui-react'
# import 'jquery-color/jquery.color.svg-names'
{Color, extend} = $
extend Color.names, css_color_names

rgba_obj_from_color_str = (str) ->
  [r, g, b, a] = Color(str).rgba()
  {r, g, b, a}

export default class ColorInput extends React.Component
  constructor: ({value}) ->
    super()
    @state =
      color: rgba_obj_from_color_str value
      editing: no
  handle_change_complete: (color) =>
    {onChange} = @props
    console.log {color}
    {rgb: {r, g, b, a}, hex} = color

    onChange(
      if a < 1
        "rgba(#{r}, #{g}, #{b}, #{a})"
      else
        hex
    )

    @setState {color}
  toggle_editing: =>
    {editing} = @state

    @setState editing: not editing
  componentWillReceiveProps: ({value}) ->
    @setState color: rgba_obj_from_color_str value
  render: ->
    {onChange, value} = @props
    {color, editing} = @state

    if editing
      %PhotoshopPicker{
        color
        onChangeComplete: @handle_change_complete
        onClose: @toggle_editing
        colorNames: css_color_names
      }
    else
      %ColorButton{ color, value, onClick: @toggle_editing }

ColorButton = ({color, value, onClick}) ->
  {r, g, b, a} = color.rgb ? color

  %Dropdown.selection{
    onClick
    text: value
    icon:
      name: 'circle'
      className: has
        color: "rgba(#{r}, #{g}, #{b}, #{a})"
        bordered: yes
  }
