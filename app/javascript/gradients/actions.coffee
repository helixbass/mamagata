import axios from 'axios'
import qs from 'qs'
import get_mixin_args from './selectors/get_mixin_args'
import mapValues from 'lodash/mapValues'
import fromPairs from 'lodash/fromPairs'

export set_mixins = ({mixins}) ->
  (dispatch) ->
    axios.get '/projects/render_sass',
      params:
        sass: fromPairs([
          mixin.name
          """
            @import 'gradient_patterns';

            .selector {
                @include #{mixin.name};
            }
          """
        ] for mixin_name, mixin of mixins)
      paramsSerializer: (params) ->
        qs.stringify params, arrayFormat: 'brackets'
    .then ({data}) -> data
    .then ({css}) ->
      dispatch {
        type: 'SET_MIXINS'
        mixins:
          mapValues mixins, (mixin, mixin_name) -> {
            mixin...
            preview_css: extract_css_rules css[mixin_name]
          }
      }

extract_css_rules = (css) ->
  match = ///
    \.selector
    \s +
    {
    ([^}] +)
    }
  ///.exec css
  [all, rules] = match
  rules

export set_current_mixin = (mixin) ->
  (dispatch, getState) ->
    dispatch {
      type: 'SET_CURRENT_MIXIN'
      mixin
    }

    render_current_mixin {mixin, dispatch, getState}

export update_mixin_arg = ({mixin, name, value}) ->
  (dispatch, getState) ->
    dispatch {
      type: 'UPDATE_MIXIN_ARG'
      name, value
    }

    render_current_mixin {mixin, dispatch, getState}

render_current_mixin = ({mixin, dispatch, getState}) ->
  mixin_args = get_mixin_args do getState
  axios.get '/projects/render_sass',
    params:
      sass: """
        @import 'gradient_patterns';

        .app {
            @include #{mixin.name}(#{
              (for {name, value} in mixin_args
                "$#{name}: #{value}"
              ).join ', '
            });
        }
      """
  .then ({data}) -> data
  .then ({css}) ->
    dispatch {
      type: 'SET_CURRENT_MIXIN_CSS'
      css
    }

    old_sheet = document.querySelector '#app_sheet'
    document.head.removeChild old_sheet if old_sheet
    sheet = document.createElement 'style'
    sheet.id = 'app_sheet'
    sheet.innerHTML = css
    document.head.appendChild sheet
