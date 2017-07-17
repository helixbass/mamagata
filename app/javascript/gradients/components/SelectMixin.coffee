import {connect} from 'react-redux'
import {capitalize} from 'underscore.string'
import {set_current_mixin} from '../actions'
import dashed_to_label from '../helpers/dashed_to_label'

SelectMixin  = ({mixins, current_mixin, handle_change}) ->
  %select{
    onChange: handle_change
    value: current_mixin.name
  }
    = %MixinOption{
      mixin
      key: mixin.name
    } for mixin_name, mixin of mixins
export default connect(
  null
  (dispatch, {mixins}) ->
    handle_change: ({target: {value}}) ->
      dispatch set_current_mixin mixins[value]
) SelectMixin

MixinOption = ({mixin: {name}}) ->
  %option{
    value: name
  }= dashed_to_label name
