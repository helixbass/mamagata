import {connect} from 'react-redux'
import {capitalize} from 'underscore.string'
import {set_current_mixin, load_saved as _load_saved} from '../actions'
import dashed_to_label from '../helpers/dashed_to_label'
import get_saved from '../helpers/get_saved'
import get_working_on_saved from '../selectors/get_working_on_saved'
import {Form} from 'semantic-ui-react'
{Field} = Form

SelectMixin = ({mixins, current_mixin, handle_change, load_saved}) ->
  saved = do get_saved

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
    = if saved?.length
      %Field
        %select{
          onChange: load_saved
          value: ''
        }
          %option{ value: '' } Load saved:
          = for {name, mixin_name} in saved
            %option{ value: name, key: name }
              {name} ({dashed_to_label mixin_name})
export default connect(
  (state) ->
    working_on_saved: get_working_on_saved state
  (dispatch, {mixins}) ->
    handle_change: ({target: {value}}) ->
      dispatch set_current_mixin mixins[value]
    load_saved: ({target: {value}}) ->
      dispatch _load_saved name: value
) SelectMixin

MixinOption = ({mixin: {name}}) ->
  %option{
    value: name
  }= dashed_to_label name
