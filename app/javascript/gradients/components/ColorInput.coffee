import {connect} from 'react-redux'
import {css as has} from 'glamor'
import {SketchPicker} from 'react-color'
import css_color_names from '../helpers/css_color_names'
import $ from 'jquery'
import 'jquery-color'
import {Menu, Label, Dropdown, Icon} from 'semantic-ui-react'
# import 'jquery-color/jquery.color.svg-names'
{Color, extend} = $
extend Color.names, css_color_names
import {add_preset_color as _add_preset_color} from '../actions'
import get_preset_colors from '../selectors/get_preset_colors'

rgba_obj_from_color_str = (str) ->
  [r, g, b, a] = Color(str).rgba()
  {r, g, b, a}

class ColorInput extends React.Component
  constructor: (props) ->
    {value, auto_open} = props
    super props
    @state =
      color: rgba_obj_from_color_str value
      editing: !! auto_open
  color_str: (color) ->
    color = rgb: color unless color.rgb?
    {rgb: {r, g, b, a}} = color

    if a < 1
      "rgba(#{r}, #{g}, #{b}, #{a})"
    else
      color.hex ? Color(
        red: r
        green: g
        blue: b
      ).toHexString()
  handle_change_complete: (color) =>
    {onChange} = @props

    onChange @color_str color

    @setState {color}
  toggle_editing: =>
    {preset_colors, add_preset_color} = @props
    {editing, color} = @state

    if editing and color
      color_str = @color_str color
      add_preset_color color_str unless color_str in preset_colors

    @setState editing: not editing
  componentWillReceiveProps: ({value}) ->
    @setState color: rgba_obj_from_color_str value
  render: ->
    {onChange, value, preset_colors} = @props
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
          presetColors: preset_colors
        }
    else
      %ColorButton{ color, value, onClick: @toggle_editing }
export default connect(
  (state) ->
    preset_colors: get_preset_colors state
  (dispatch) ->
    add_preset_color: (color) ->
      dispatch _add_preset_color color
) ColorInput

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
