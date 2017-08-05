import {connect} from 'react-redux'
import {capitalize} from 'underscore.string'
import {set_current_mixin, load_saved as _load_saved} from '../actions'
import dashed_to_label from '../helpers/dashed_to_label'
import {Form} from 'semantic-ui-react'
{Field} = Form

SelectMixin = ({mixins, current_mixin, handle_change}) ->
  %Form
    %Field
      %label Pattern
      %select{
        onChange: handle_change
        value: current_mixin.name
      }
        = %MixinOption{
          mixin
          key: mixin.name
        } for mixin_name, mixin of mixins
export default connect(
  (dispatch, {mixins}) ->
    handle_change: ({target: {value}}) ->
      dispatch set_current_mixin mixins[value]
) SelectMixin

MixinOption = ({mixin: {name}}) ->
  %option{
    value: name
  }= dashed_to_label name
