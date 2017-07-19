import {connect} from 'react-redux'
import get_mixin_args from '../selectors/get_mixin_args'

class AnimationEditor extends React.Component
  render: ->
    {mixin, args} = @props

    .animation-editor
export default AnimationEditor = connect(
  (state) ->
    args: get_mixin_args state
) AnimationEditor
