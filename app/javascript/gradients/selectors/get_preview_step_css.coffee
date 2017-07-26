import parse_css_props from '../helpers/parse_css_props'

export default ({animation_steps}) ->
  [css] = (css for {css, preview} in animation_steps when preview)
  return unless css
  parse_css_props {css}
