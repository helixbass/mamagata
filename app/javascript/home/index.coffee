import ReactDOM from 'react-dom'
import {Header, Segment, Card, Icon, Image, Item, Container, List, Divider} from 'semantic-ui-react'
import 'semantic-ui-css/semantic.min.css'
import './home.sass'
import {css as has} from 'glamor'

document.addEventListener 'DOMContentLoaded', ->
  ReactDOM.render(
    %Home
    document.body.appendChild document.createElement 'div'
  )

Home = ->
  %Container.(has
    marginBottom: 40
  )
    %Header{
      as: 'h1'
      floated: 'left'
    } Julian Rosse
    %Header{
      as: 'h3'
      floated: 'left'
    } Full-stack developer

    %List.contact{
      floated: 'right'
      size: 'large'
    }
      %List.Item
        %List.Icon{ name: 'point' }
        %List.Content New York, NY
      %List.Item
        %List.Icon{ name: 'mail outline' }
        %List.Content
          %a{ href: 'mailto:julian@helixbass.net' } julian@helixbass.net
      %List.Item
        %List.Icon{ name: 'phone' }
        %List.Content 704 564 5090

    %List.contact{
      floated: 'left'
      size: 'large'
    }
      %List.Item
        %List.Icon{ name: 'home' }
        %List.Content
          %a{ href: 'http://helixbass.net' } helixbass.net
      %List.Item
        %List.Icon{ name: 'github' }
        %List.Content
          %a{ href: 'https://github.com/helixbass' } helixbass
      %List.Item
        %List.Icon{ name: 'briefcase' }
        %List.Content
          %a Resume

    %Divider{
      clearing: yes
      hidden: yes
    }

    %Header{
      as: 'h3'
      content: 'Projects'
      icon: 'lab'
    }
    %Card.Group
      %Card{
        href: '/projects/jsxy'
      }
        %Image{ src: '' }
        %Card.Content
          %Card.Header Coffeescript-JSXY
          %Card.Meta Write beautifully clean React components
          %Card.Description
            %a{ href: 'http://haml.info' } Haml
            -inspired JSX syntax built on
            %a{ href: 'http://coffeescript.org/v2' }^ CoffeeScript 2
      %Card{ href: '/projects/gradients' }
        %Image{ src: '' }
        %Card.Content
          %Card.Header CSS3 Gradient Pattern Tool
          %Card.Meta Customize &amp; animate CSS3 patterns
          %Card.Description
            Interactively tailor and animate CSS3 gradient patterns.
            Includes all patterns from
            %a{ href: 'http://lea.verou.me/css3patterns' }^ Lea Verou's gallery
            and
            %a{ href: 'http://lea.verou.me/css3patterns' }^
              Bennett Feely's
              %code^ background-blend-mode
              gallery
      %Card{ href: 'https://github.com/helixbass/animate-backgrounds' }
        %Image{ src: '' }
        %Card.Content
          %Card.Header animate-backgrounds
          %Card.Meta
            %Icon{ name: 'github' }
            %span helixbass/animate-backgrounds
          %Card.Description
            Animate CSS3 gradients, <code>background-size</code>, and <code>background-position</code>.
            Plugs into
            %a{ href: 'http://jquery.com' }^ jQuery
            or
            %a{ href: 'http://animejs.com' }^ anime.js
      %Card{ href: 'https://github.com/helixbass/sass-gradient-patterns' }
        %Image{ src: '' }
        %Card.Content
          %Card.Header sass-gradient-patterns
          %Card.Meta
            %Icon{ name: 'github' }
            %span helixbass/sass-gradient-patterns
          %Card.Description
            %a{ href: 'http://sass-lang.com' }^ Sass mixins
            for CSS3 gradient patterns
      %Card{ href: 'https://github.com/helixbass/copheescript' }
        %Image{ src: '' }
        %Card.Content
          %Card.Header Copheescript
          %Card.Meta CoffeeScript -> PHP
          %Card.Description
            Hacked the CoffeeScript compiler to output PHP.
            Used for all new back-end code last 2+ years at Zeel

    %Header{
      as: 'h3'
      icon: 'history'
      attached: 'top'
      content: 'Experience'
    }
    %Segment{ attached: yes }
      %Item.Group
        %Item
          %Item.Content
            %Item.Header Funemployment (hacking/learning/traveling in Mexico)
            %Item.Meta 2017 thus far
            %Item.Description
              %ul
                %li
                  implementing CoffeeScript-JSXY
                  (and contributing actively to <a href='http://github.com/jashkenas/coffeescript'>CoffeeScript proper</a>)
                %li
                  learning React/Redux/Webpack
                  (used for real projects, eg <a href='/projects/gradients'>CSS3 Gradient Pattern Tool</a>)
                %li playing with front-end/animation stuff
        %Item
          %Item.Content
            %Item.Header Zeel Massage on Demand (New York, >1 year remote from CO)
            %Item.Meta Nov 2013&mdash;Dec 2016: Full-stack developer
            %Item.Description
              %ul
                %li one of only two web devs for most of my time there
                %li
                  built frameworks
                  (ORM, RESTful APIs,
                  %a{ href: 'https://github.com/helixbass/copheescript' }^ Copheescript
                  -> PHP, ...) to simplify day-to-day coding
                %li focused on CMS (using Angular 1.x) and reporting (MySQL via custom ORM)
                %li rearchitected and reimplemented major backend systems resulting in major flexibility and productivity gains
        %Item
          %Item.Content
            %Item.Header Freelance web developer
            %Item.Meta 2006&mdash;2013: Mostly Python
            %Item.Description
              %ul
                %li worked single-handedly or with design partners to produce data-backed websites for clients
                %li built Sleepy framework (Python) to generate XQuery DB, RESTful APIs and CMS interface from YAML config
        %Item
          %Item.Content
            %Item.Header Educational Testing Service (Princeton, NJ)
            %Item.Meta 2002&mdash;2006: Web programmer/data analyst
            %Item.Description
              %ul
                %li developed interactive web-based reporting and data analysis tools

    %Header{
      as: 'h3'
      icon: 'lab'
      attached: 'top'
      content: 'Projects'
    }
    %Segment{ attached: yes }

    %Header.(has
      padding: '.78571429rem .8rem !important'
    ){
      as: 'h3'
      icon: 'student'
      content: "Swarthmore '04 CS/Math"
    }

    %Header{
      as: 'h3'
      icon: 'heart'
      attached: 'top'
      content: 'Values'
    }
    %Segment{ attached: yes }
      %ul
        %li User experience &lt;==> enlightenment
        %li
          Unabashed apprenticeship, fandom, and humility create sustainable paths
          of learning and growth
        %li Thinking like a systems programmer regardless of the task
        %li Iterative, feedback-driven development
