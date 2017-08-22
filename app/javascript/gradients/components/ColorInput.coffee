import {css as has} from 'glamor'
import {SketchPicker} from 'react-color'
import css_color_names from '../helpers/css_color_names'
import $ from 'jquery'
import 'jquery-color'
import {Menu, Label, Dropdown, Icon} from 'semantic-ui-react'
# import 'jquery-color/jquery.color.svg-names'
{Color, extend} = $
extend Color.names, css_color_names

rgba_obj_from_color_str = (str) ->
  [r, g, b, a] = Color(str).rgba()
  {r, g, b, a}

export default class ColorInput extends React.Component
  constructor: (props) ->
    {value, auto_open} = props
    super props
    @state =
      color: rgba_obj_from_color_str value
      editing: !! auto_open
  handle_change_complete: (color) =>
    {onChange} = @props
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
      .(has position: 'relative')
        %Icon{
          name: 'window close outline'
          link: yes
          fitted: yes
          onClick: @toggle_editing
          style:
            position: 'absolute'
            top: -20
            right: 0
            zIndex: 500
        }
        %SketchPicker{
          color
          onChangeComplete: @handle_change_complete
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
