import axios from 'axios'
import qs from 'qs'
import get_mixin_args from './selectors/get_mixin_args'
import get_current_mixin from './selectors/get_current_mixin'
import get_mixins from './selectors/get_mixins'
import get_animation_steps from './selectors/get_animation_steps'
import get_loop from './selectors/get_loop'
import get_sass_and_css from './helpers/get_sass_and_css'
import get_saved from './helpers/get_saved'
import _save from './helpers/save'
import {color_name} from './helpers/css_color_names'
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

export set_current_mixin = (mixin, {render=yes}={}) ->
  (dispatch, getState) ->
    {preview_css} = mixin

    el = document.querySelector '.app'
    el.setAttribute 'style', ''

    dispatch {
      type: 'SET_CURRENT_MIXIN'
      mixin
    }

    set_preview_css ".app {#{preview_css}}" if preview_css

    render_current_mixin {mixin, dispatch, getState} if render

export update_mixin_arg = ({mixin, name, value}) ->
  (dispatch, getState) ->
    dispatch {
      type: 'UPDATE_MIXIN_ARG'
      name
      value: color_name value
    }

    render_current_mixin {mixin, dispatch, getState}

render_current_mixin = ({mixin, dispatch, getState}) ->
  state = do getState
  mixin ?= get_current_mixin state

  get_sass_and_css {
    mixin
    mixin_args: get_mixin_args state
  }
  .then ({sass, css}) ->
    dispatch {
      type: 'UPDATE_CURRENT_MIXIN'
      css, sass
    }

    set_preview_css css

set_preview_css = (css) ->
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

export play_animation = ->
  type: 'PLAY_ANIMATION'

export update_loop = ({loop: _loop}) -> {
  type: 'UPDATE_LOOP'
  loop: _loop
}

export pause_animation = ->
  type: 'PAUSE_ANIMATION'

export reset_animation = ->
  type: 'RESET_ANIMATION'

export set_animation_progress = ({progress}) -> {
  type: 'SET_ANIMATION_PROGRESS'
  progress
}

export toggle_step_preview = ({step_index}) -> {
  type: 'TOGGLE_STEP_PREVIEW'
  step_index
}

export toggle_animation_step = ({step_index}) -> {
  type: 'TOGGLE_ANIMATION_STEP'
  step_index
}

export seek_animation = ({time}) -> {
  type: 'SEEK_ANIMATION'
  time
}

export did_reset_animation = ->
  type: 'DID_RESET_ANIMATION'

export sought_animation = ->
  type: 'SOUGHT_ANIMATION'

export completed_animation = ->
  type: 'COMPLETED_ANIMATION'

export update_step = ({step_index, props...}) -> {
  type: 'UPDATE_STEP'
  step_index, props...
}

export delete_step = ({step_index}) -> {
  type: 'DELETE_STEP'
  step_index
}

export reorder_step = ({step_index, before_step_index}) -> {
  type: 'REORDER_STEP'
  step_index, before_step_index
}

export delete_step_arg = ({step_index, name}) -> {
  type: 'DELETE_STEP_ARG'
  step_index, name
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
      step_index, name
      value: color_name value
    }

export load_saved = ({name}) ->
  (dispatch, getState) ->
    saved = find get_saved(), {name}
    {mixin_name} = saved

    dispatch set_current_mixin(
      get_mixins(do getState)[mixin_name]
      render: no
    )

    dispatch {
      type: 'LOAD_SAVED'
      saved
    }

    render_current_mixin {dispatch, getState}

export save = ({name}) ->
  (dispatch, getState) ->
    state = do getState

    mixin_args = get_mixin_args state
    animation_steps = get_animation_steps state
    _loop = get_loop state
    {name: mixin_name} = get_current_mixin state

    data = {
      mixin_args, animation_steps
      mixin_name, name
      loop: _loop
    }

    _save data

    dispatch {
      type: 'SAVE'
      data...
    }
