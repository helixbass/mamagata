import {connect} from 'react-redux'
import {capitalize} from 'underscore.string'
import {css as has} from 'glamor'
import {set_current_mixin, load_saved as _load_saved} from '../actions'
import dashed_to_label from '../helpers/dashed_to_label'
import parse_css_props from '../helpers/parse_css_props'
import groupBy from 'lodash/groupBy'
import {Form, Dropdown, Modal, Card, Header} from 'semantic-ui-react'
{Field} = Form
{Content, Description} = Modal

class SelectMixin extends React.Component
  constructor: (props) ->
    super props

    @state =
      choosing: no
  show_patterns: =>
    @setState choosing: yes
  hide_patterns: =>
    @setState choosing: no
  render: ->
    {mixins, current_mixin, handle_change} = @props
    {choosing} = @state

    %div
      %Form
        %Field{ inline: yes }
          %label Pattern
          %Dropdown.tiny{
            onClick: @show_patterns
            text: dashed_to_label current_mixin.name
          }
      %ChoosePattern{ mixins, current_mixin, handle_change, choosing, @hide_patterns }
export default connect(
  null
  (dispatch, {mixins}) ->
    handle_change: (mixin_name) -> ->
      dispatch set_current_mixin mixins[mixin_name]
) SelectMixin

ChoosePattern = ({mixins, current_mixin, handle_change, choosing, hide_patterns}) ->
  %Modal{
    open: choosing
    onClose: hide_patterns
    closeIcon: 'close'
  }
    %Modal.Header Choose a pattern
    %Content{ scrolling: yes }
      %Description
        = %PatternGroup{
          group, group_name
          handle_change, hide_patterns
          key: group_name
        } for group_name, group of groupBy mixins, ({group}) -> group if group in ['lea-verou', 'blend-modes']

PatternGroup = ({group, group_name, handle_change, hide_patterns}) ->
  .(has
    marginBottom: 30
  )
    %Header{
      as: 'h3'
      dividing: yes
    }
      = switch group_name
        when 'lea-verou'
          %span
            from Lea Verou's
            %a{ href: 'http://lea.verou.me/css3patterns/' }^
              CSS3 Patterns Gallery
        when 'blend-modes'
          %span
            from Bennett Feely's
            %a{ href: 'http://bennettfeely.com/gradients/' }^
              %code^ background-blend-mode
              gallery
        else
          'other'
    %Card.Group{ itemsPerRow: 3 }
      = %PatternPreview{ mixin, handle_change, hide_patterns, key: mixin_name } for mixin_name, mixin of group

PatternPreview = ({mixin: {name, preview_css}, handle_change, hide_patterns}) ->
  %Card.(has
    cursor: 'pointer'
  ){
    onClick: (event) ->
      handle_change(name) event
      do hide_patterns
  }
    %Card.Content
      %div.(has
        marginBottom: 10
      ){
        style: {
          width: '100%'
          height: 85
          parse_css_props(css: preview_css)...
        }
      }
      %Card.Header
        = dashed_to_label name
