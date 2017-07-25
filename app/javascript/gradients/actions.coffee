import axios from 'axios'
import qs from 'qs'
import get_mixin_args from './selectors/get_mixin_args'
import get_current_mixin from './selectors/get_current_mixin'
import get_sass_and_css from './helpers/get_sass_and_css'
import mapValues from 'lodash/mapValues'
import fromPairs from 'lodash/fromPairs'
import find from 'lodash/find'

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
    el = document.querySelector '.app'
    el.setAttribute 'style', ''

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
  get_sass_and_css {
    mixin
    mixin_args: get_mixin_args do getState
  }
  .then ({sass, css}) ->
    dispatch {
      type: 'UPDATE_CURRENT_MIXIN'
      css, sass
    }

    old_sheet = document.querySelector '#app_sheet'
    document.head.removeChild old_sheet if old_sheet
    sheet = document.createElement 'style'
    sheet.id = 'app_sheet'
    sheet.innerHTML = css
    document.head.appendChild sheet

export add_animation_step = ->
  type: 'ADD_ANIMATION_STEP'

export set_animation_step_shorthand = ({step_index, shorthand}) -> {
  type: 'SET_ANIMATION_STEP_SHORTHAND'
  step_index, shorthand
}

export play_or_pause_animation = ->
  type: 'PLAY_OR_PAUSE_ANIMATION'

export set_animation_progress = ({progress}) -> {
  type: 'SET_ANIMATION_PROGRESS'
  progress
}

export expand_animation_step = ({step_index}) -> {
  type: 'EXPAND_ANIMATION_STEP'
  step_index
}

export seek_animation = ({time}) -> {
  type: 'SEEK_ANIMATION'
  time
}

export sought_animation = ->
  type: 'SOUGHT_ANIMATION'

export completed_animation = ->
  type: 'COMPLETED_ANIMATION'

export update_step_duration = ({step_index, duration}) -> {
  type: 'UPDATE_STEP_DURATION'
  step_index, duration
}

export update_step_arg = ({step_index, name, value}) ->
  (dispatch, getState) ->
    value ?= # TODO: for multiple steps this should be the value from the preceding step
      find(
        get_mixin_args do getState
        {name}
      )
      .value

    dispatch {
      type: 'UPDATE_STEP_ARG'
      step_index, name, value
    }
