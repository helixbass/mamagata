import debounce from 'lodash/debounce'
import BaseComponent from './BaseComponent'

export default class DebouncedInput extends BaseComponent
  sync_state_to_props: 'value'
  constructor: (props) ->
    {value, onChange} = props
    super props

    @state = {value}
    @changed = debounce onChange, 300

  handle_change: ({target: {value}}) =>
    @setState {value}, =>
      @changed value

  render: ->
    {value, onChange, attrs...} = @props
    {value = ''} = @state

    %input{
      value, attrs...
      onChange: @handle_change
    }
