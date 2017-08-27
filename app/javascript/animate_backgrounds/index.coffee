import ReactDOM from 'react-dom'
import {Container, Dropdown, Header} from 'semantic-ui-react'
# import 'semantic-ui-css/semantic.min.css' TODO: revert once https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/573 is fixed
import 'semantic-ui-css/semantic.css'
import './animate_backgrounds.sass'
import {css as has} from 'glamor'
import anime from 'animejs-hooks'
import 'animate-backgrounds/animate-backgrounds.anime'
import $ from 'jquery'
import 'animate-backgrounds/animate-backgrounds.jquery'
import uuid from 'uuid/v4'
import isArray from 'lodash/isArray'
import omit from 'lodash/omit'

document.addEventListener 'DOMContentLoaded', ->
  ReactDOM.render(
    %Docs
    document.body.appendChild document.createElement 'div'
  )

Docs = ->
  %Container.(has
    marginBottom: 40
    paddingTop: 40
  )
    %Header{
      as: 'h1'
    } animate-backgrounds

    %p
      %code^ animate-backgrounds
      allows you to animate CSS3 gradients (inside <code>background-image</code>), <code>background-size</code>, and
      %code^ background-position
      using either
      %a{ href: 'http://jquery.com' }^ jQuery
      or a
      %a{ href: 'https://github.com/helixbass/animejs-hooks' }^ hook-enabled version
      of AnimeJS.

    %p
      See the
      %a{ href: 'https://github.com/helixbass/animate-backgrounds' }^ README
      for installation/usage and supported syntax

    %p
      Try the
      %a{ href: '/projects/gradients' }^ interactive tool
      to easily animate some cool gradient patterns

    %p
      Here, we look at examples of the different aspects
      of gradients, <code>background-size</code>,
      and <code>background-position</code> that can be animated
      using <code>animate-backgrounds</code>.
      For any example, choose between jQuery or AnimeJS
      and shorthand or standard syntax.
      Click the gradient background to run

    %Example{
      title: 'Stop color'
      css:
        backgroundImage: 'radial-gradient(circle at bottom left, aquamarine 25%, deepskyblue 25%)'
      js:
        standard:
          backgroundImage:
            'radial-gradient(circle at bottom left, aquamarine 25%, magenta 25%)'
        shorthand:
          backgroundImage:
            'deepskyblue -> magenta'
    }

    %Example{
      title: 'Stop position'
      css:
        backgroundImage: 'radial-gradient(circle at bottom left, aquamarine 25%, deepskyblue 25%)'
      js:
        standard:
          backgroundImage:
            'radial-gradient(circle at bottom left, aquamarine 50%, deepskyblue 50%)'
        shorthand:
          backgroundImage:
            '25% -> 50%'
    }

    %Example{
      title: 'Stop color and position'
      css:
        backgroundImage: 'radial-gradient(circle at bottom left, aquamarine 25%, deepskyblue 25%)'
      js:
        standard:
          backgroundImage:
            'radial-gradient(circle at bottom left, aquamarine 50%, magenta 50%)'
        shorthand:
          backgroundImage:
            '25% -> 50%, deepskyblue -> magenta'
    }

    %Example{
      title: 'Starting point (radial)'
      css:
        backgroundImage: 'radial-gradient(circle at 0% 100%, aquamarine 25%, deepskyblue 45%)'
      js:
        standard:
          backgroundImage:
            'radial-gradient(circle at 0% 0%, aquamarine 25%, deepskyblue 45%)'
        shorthand:
          backgroundImage:
            '100% -> 0%'
    }

    %Example{
      title: 'Extent (radial)'
      css:
        backgroundImage: 'radial-gradient(circle 200px at 0% 100%, aquamarine 25%, deepskyblue 45%)'
      js:
        standard:
          backgroundImage:
            'radial-gradient(circle 400px at 0% 100%, aquamarine 25%, deepskyblue 45%)'
        shorthand:
          backgroundImage:
            '200px -> 400px'
    }

    %Example{
      title: 'Angle (linear)'
      css:
        backgroundImage: 'repeating-linear-gradient(45deg, gainsboro 0px, gainsboro 25px, orchid 25px, orchid 50px)'
      js:
        standard:
          backgroundImage:
            'repeating-linear-gradient(90deg, gainsboro 0px, gainsboro 25px, orchid 25px, orchid 50px)'
        shorthand:
          backgroundImage:
            '45deg -> 90deg'
    }

    %Example{
      title: 'Background position'
      css:
        backgroundImage: '
          repeating-linear-gradient(45deg, transparent 0, transparent 25%, rgba(0, 150, 150, 0.5) 25%, rgba(0, 150, 150, 0.5) 50%),
          repeating-linear-gradient(135deg, transparent 0, transparent 25%, rgba(0, 150, 150, 0.5) 25%, rgba(0, 150, 150, 0.5) 50%)'
        backgroundSize: '70px 70px, 70px 70px'
        backgroundPosition: '0 0, 0 0'
      js:
        standard:
          backgroundPosition:
            '25px 0, 0 0'
        shorthand:
          backgroundPosition:
            '[0] 25px 0'
    }

    %Example{
      title: 'Background size'
      css:
        backgroundImage: '
          repeating-linear-gradient(45deg, transparent 0, transparent 25%, rgba(0, 150, 150, 0.5) 25%, rgba(0, 150, 150, 0.5) 50%),
          repeating-linear-gradient(135deg, transparent 0, transparent 25%, rgba(0, 150, 150, 0.5) 25%, rgba(0, 150, 150, 0.5) 50%)'
        backgroundSize: '70px 70px, 70px 70px'
      js:
        standard:
          backgroundSize:
            '90px 90px, 90px 90px'
        shorthand:
          backgroundSize:
            '70px -> 90px'
    }

    %Example{
      title: 'Simultaneous'
      css:
        backgroundImage: 'repeating-linear-gradient(45deg, gainsboro 0px, gainsboro 25px, orchid 25px, orchid 50px)'
      js:
        standard: [
          backgroundImage: 'simultaneous repeating-linear-gradient(90deg, gainsboro 0px, gainsboro 25px, orchid 25px, orchid 50px)'
          duration: 1500
        ,
          backgroundImage: 'simultaneous repeating-linear-gradient(45deg, gainsboro 0px, gainsboro 25px, orchid 25px, orchid 50px)'
          duration: 1500
        ,
          backgroundImage: 'simultaneous repeating-linear-gradient(90deg, gainsboro 0px, gainsboro 25px, orchid 25px, orchid 50px)'
          duration: 1500
        ,
          backgroundImage: 'simultaneous repeating-linear-gradient(45deg, gainsboro 0px, gainsboro 25px, orchid 25px, orchid 50px)'
          duration: 1500
        ,
          backgroundImage: 'simultaneous repeating-linear-gradient(45deg, gainsboro 0px, gainsboro 25px, skyblue 25px, skyblue 50px)'
          duration: 6000
          offset: 0
        ]
        shorthand: [
          backgroundImage: 'simultaneous 45deg -> 90deg'
          duration: 1500
        ,
          backgroundImage: 'simultaneous 90deg -> 45deg'
          duration: 1500
        ,
          backgroundImage: 'simultaneous 45deg -> 90deg'
          duration: 1500
        ,
          backgroundImage: 'simultaneous 90deg -> 45deg'
          duration: 1500
        ,
          backgroundImage: 'simultaneous orchid -> skyblue'
          duration: 6000
          offset: 0
        ]
    }

path = (obj, path) ->
  steps = path.split '.'
  for step in steps
    obj = obj[step]
  obj

class Example extends React.Component
  constructor: (props) ->
    super props
    {js} = props
    @state =
      id: "a#{do uuid}"
      version: 'anime.shorthand'
      duration: 1500
      js: @normalize_js js

  normalize_js: (js) ->
    return js if 'anime' of js
    anime: js
    jquery: js

  handle_engine_change: (event, {value}) =>
    {version} = @state
    [engine, syntax] = version.split '.'

    @setState
      version: "#{value}.#{syntax}"
  handle_syntax_change: (event, {value}) =>
    {version} = @state
    [engine, syntax] = version.split '.'

    @setState
      version: "#{engine}.#{value}"
  render: ->
    {title, css} = @props
    {id, version, duration, js} = @state
    id_selector = "##{id}"

    version_param =
      path js, version
    [engine, syntax] = version.split '.'

    run = (param) -> ->
      el = document.querySelector id_selector
      for prop_name, prop_val of css
        el.style[prop_name] = prop_val

      if engine is 'anime'
        step_params = (step) -> {
          targets: id_selector
          duration
          easing: 'linear'
          step...
        }
        anim =
          if isArray param
            timeline = anime.timeline()
            for step in param
              timeline.add step_params step
            timeline
          else
            anime step_params param
        console.log {anim}
        anim
      else
        if isArray param
          $el = $ id_selector
          for step in param
            {duration, offset} = step
            $el.animate(
              omit step, ['duration', 'offset']
              duration: step.duration
              queue: not offset?
              easing: 'linear'
            )
        else
          $ id_selector
          .animate param, {
            duration
            easing: 'linear'
          }

    fake_target = "'.EL'"
    js_str =
      if engine is 'anime'
        if isArray version_param
          """
            anime.timeline()#{
              (for step in version_param
                """
                  \n.add({
                    targets: #{fake_target},
                    duration: #{step.duration},#{
                      if step.offset?
                        "\n  offset: #{step.offset},"
                      else '' }
                    easing: 'linear',#{
                      (for prop_name, prop_val of step when prop_name not in ['offset', 'duration']
                        "\n  #{prop_name}: '#{prop_val}',"
                      ).join '' }
                  })
                """
              ).join '' }
          """
        else
          """
            anime({
              targets: #{fake_target},
              duration: #{duration},
              easing: 'linear',#{
                (for prop_name, prop_val of version_param
                  "\n  #{prop_name}: '#{prop_val}',"
                ).join '' }
            })
          """
      else
        if isArray version_param
          if syntax is 'shorthand'
            """
              $(#{fake_target})#{
                (for step in version_param
                  """
                    \n.animate({#{
                      (for prop_name, prop_val of omit step, ['duration', 'offset']
                        "\n    #{prop_name}: '#{prop_val}',"
                      ).join '' }
                      },
                      {
                        duration: #{step.duration},
                        easing: 'linear',#{
                          if step.offset?
                            "\n    queue: false,"
                          else ''
                        }
                      })
                  """
                ).join '' }
            """
          else
            """
              NOTE: since jQuery's .animate() doesn't set up all animations initially (before any of them run), you'll probably run into problems trying to use standard syntax with simultaneous animations when using jQuery (because it'll read intermediate values for the animation start value and get confused about what's actually changing).

              So using shorthand syntax is recommended when doing simultaneous animations with jQuery
            """
        else
          """
            $(#{fake_target})
            .animate({#{
              (for prop_name, prop_val of version_param
                "\n    #{prop_name}: '#{prop_val}',"
              ).join '' }
              },
              {
                duration: #{duration},
                easing: 'linear'
              })
          """

    %table
      %tbody
        %tr
          %td
            %h3= title
            .(has
              width: 150
              height: 100
            ){
              id
              style: css
              onClick: run version_param
            }
          %td.(has
            maxWidth: '30em'
          )
            %h5.(has
              margin: '.5rem 0 .4rem !important'
            ) Start values
            %pre.(has
              marginTop: '.4rem'
            )
              = for prop_name, prop_val of css
                "#{camel_to_dashed prop_name}: #{prop_val};\n"
          %td.(has
            maxWidth: '30em'
          )
            %h5.(has
              margin: '.5rem 0 .4rem !important'
            )
              Use
              %Dropdown{
                inline: yes
                options: [
                  text: 'AnimeJS'
                  value: 'anime'
                ,
                  text: 'jQuery'
                  value: 'jquery'
                ]
                value: engine
                onChange: @handle_engine_change
              }^
              with
              %Dropdown{
                inline: yes
                options: [
                  text: 'shorthand'
                  value: 'shorthand'
                ,
                  text: 'standard'
                  value: 'standard'
                ]
                value: syntax
                onChange: @handle_syntax_change
              }^
              syntax
            %pre.(has
              marginTop: '.4rem'
            )= js_str

camel_to_dashed = (str) ->
  str.replace /[A-Z]/g, (cap) -> "-#{cap.toLowerCase()}"
