import ReactDOM from 'react-dom'
import {Container, Dropdown, Header} from 'semantic-ui-react'
import 'semantic-ui-css/semantic.min.css'
import './animate_backgrounds.sass'
import {css as has} from 'glamor'
import anime from 'animejs-hooks'
import 'animate-backgrounds/animate-backgrounds.anime'
import $ from 'jquery'
import 'animate-backgrounds/animate-backgrounds.jquery'
import uuid from 'uuid/v4'

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
      See
      %a{ href: 'https://github.com/helixbass/animate-backgrounds' }^ here
      for installation/usage and supported syntax

    %p
      Here, we look at examples of the different aspects
      of gradients, <code>background-size</code>,
      and <code>background-position</code> that can be animated
      using <code>animate-backgrounds</code>.
      For any example, choose between jQuery or AnimeJS
      and shorthand or standard syntax.
      Click the gradient background to run

    %Example{
      title: 'Single color'
      css:
        backgroundImage: 'radial-gradient(circle at bottom left, aquamarine 25%, deepskyblue 25%)'
      js:
        anime:
          standard:
            backgroundImage:
              'radial-gradient(circle at bottom left, aquamarine 25%, magenta 25%)'
          shorthand:
            backgroundImage:
              'deepskyblue -> magenta'
        jquery:
          standard:
            backgroundImage:
              'radial-gradient(circle at bottom left, aquamarine 25%, magenta 25%)'
          shorthand:
            backgroundImage:
              'deepskyblue -> magenta'
    }

path = (obj, path) ->
  steps = path.split '.'
  for step in steps
    obj = obj[step]
  obj

class Example extends React.Component
  constructor: (props) ->
    super props
    @state =
      id: "a#{do uuid}"
      version: 'anime.shorthand'
      duration: 1500

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
    {title, css, js} = @props
    {id, version, duration} = @state
    id_selector = "##{id}"

    version_param =
      path js, version
    [engine, syntax] = version.split '.'

    run = (param) -> ->
      el = document.querySelector id_selector
      for prop_name, prop_val of css
        el.style[prop_name] = prop_val

      if engine is 'anime'
        anime {
          targets: id_selector
          duration
          easing: 'linear'
          param...
        }
      else
        $ id_selector
        .animate param, {
          duration
          easing: 'linear'
        }

    js_str =
      if engine is 'anime'
        """
          anime({
            targets: '.el',
            duration: #{duration},
            easing: 'linear',#{
              for prop_name, prop_val of version_param
                "\n  #{prop_name}: '#{prop_val}'," }
          })
        """
      else
        """
          $(".el")
          .animate({#{
            for prop_name, prop_val of version_param
              "\n    #{prop_name}: '#{prop_val}'," }
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
                "#{camel_to_dashed prop_name}: #{prop_val};"
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
