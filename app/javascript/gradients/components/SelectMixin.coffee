import {connect} from 'react-redux'
import {capitalize} from 'underscore.string'
import {css as has} from 'glamor'
import {set_current_mixin, load_saved as _load_saved} from '../actions'
import dashed_to_label from '../helpers/dashed_to_label'
import parse_css_props from '../helpers/parse_css_props'
import BaseComponent from './BaseComponent'
import groupBy from 'lodash/groupBy'
import {contains} from 'underscore.string'
import {Form, Dropdown, Input, Modal, Card, Header} from 'semantic-ui-react'
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
    handle_change: (mixin_name) ->
      dispatch set_current_mixin mixins[mixin_name]
) SelectMixin

class ChoosePattern extends BaseComponent
  stateChangeHandlers: 'q'
  handle_change: (mixin_name) =>
    {handle_change} = @props

    handle_change mixin_name
    @setState q: ''
  render: ->
    {mixins, current_mixin, choosing, hide_patterns} = @props
    {q} = @state

    %Modal{
      open: choosing
      onClose: hide_patterns
      closeIcon: 'close'
    }
      %Modal.Header
        Choose a pattern
        .(has
          fontSize: 16
          float: 'right'
          marginRight: 10
        )
          %Input{
            icon: 'search'
            placeholder: 'Search by name...'
            size: 'mini'
            value: q
            onChange: @handleQChange
          }
      %Content{ scrolling: yes }
        %Description
          = %PatternGroup{
            group, group_name, q
            @handle_change, hide_patterns
            key: group_name
          } for group_name, group of groupBy mixins, ({group}) -> group if group in ['lea-verou', 'blend-modes']

PatternGroup = ({group, group_name, handle_change, hide_patterns, q}) ->
  filtered =
    mixin for mixin in group when not q or contains dashed_to_label(mixin.name).toLowerCase(), q.toLowerCase()
  return null unless filtered.length

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
      = %PatternPreview{
        mixin
        handle_change, hide_patterns
        key: mixin.name
      } for mixin in filtered

PatternPreview = ({mixin: {name, preview_css}, handle_change, hide_patterns}) ->
  %Card.(has
    cursor: 'pointer'
  ){
    onClick: ->
      handle_change name
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
