import {load_saved as _load_saved} from '../actions'
import get_saved from '../helpers/get_saved'
import dashed_to_label from '../helpers/dashed_to_label'
import {connect} from 'react-redux'
import {css as has} from 'glamor'
import {Dropdown, Icon} from 'semantic-ui-react'

LoadSaved = ({load_saved}) ->
  return null unless (saved = do get_saved)?.length

  %Dropdown.tiny{
    onChange: load_saved
    value: ''
    button: yes
    text: 'Load saved'
    options:
      for {name, mixin_name} in saved
        key: name
        value: name
        text: "#{name} (#{dashed_to_label mixin_name})"
  }
export default connect(
  null
  (dispatch) ->
    load_saved: (event, {value}) ->
      dispatch _load_saved name: value
) LoadSaved
