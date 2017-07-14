# Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
# like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
# of the page.

import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

Hello = ({name}) ->
  %div Hello {name}!

Hello.defaultProps =
  name: 'David'

Hello.propTypes =
  name: PropTypes.string

document.addEventListener 'DOMContentLoaded', ->
  ReactDOM.render(
    %Hello( name='sexy' )
    document.body.appendChild document.createElement 'div'
  )
