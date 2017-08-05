import {load_saved as _load_saved} from '../actions'
import get_saved from '../helpers/get_saved'
import dashed_to_label from '../helpers/dashed_to_label'
import {connect} from 'react-redux'
import {css as has} from 'glamor'

LoadSaved = ({load_saved}) ->
  return null unless (saved = do get_saved)?.length

  %select.(has
    position: 'absolute'
    top: 8
    left: 15
    maxWidth: 140
    zIndex: 100
  ){
    onChange: load_saved
    value: ''
  }
    %option{ value: '' } Load saved:
    = for {name, mixin_name} in saved
      %option{ value: name, key: name }
        {name} ({dashed_to_label mixin_name})
export default connect(
  null
  (dispatch) ->
    load_saved: ({target: {value}}) ->
      dispatch _load_saved name: value
) LoadSaved
