import {Modal, Header, Button, Message} from 'semantic-ui-react'
import {css as has} from 'glamor'

export default ->
  %Modal{
    trigger:
      %Button.(has
        paddingLeft: '1.3em !important'
        paddingRight: '1.3em !important'
      ){
        icon: 'question circle'
        content: 'Huh?'
        size: 'tiny'
      }
  }
    %Header{
      as: 'h1'
      icon: 'question'
      content: 'Help/About'
    }
    %Modal.Content{ scrolling: yes }
      %Modal.Description
        %Header{ as: 'h2' } How does it work?
        %p
          This page combines a couple open source libraries to let you
          customize and animate a bunch of different CSS3 gradient patterns.
          Use it to interactively craft tailored and/or animated versions
          of the included patterns and then export them to your own project
        %Header{ as: 'h4', icon: 'css3', content: 'CSS3 gradient patterns' }
        %p
          Most browsers nowadays support CSS3 linear and radial gradients as
          background images.
          %a{ href: 'http://lea.verou.me' }^ Lea Verou
          discovered that in addition to typical gradual color-changing
          gradients, you can achieve a lot of cool patterns.
          She published a
          %a{ href: 'http://lea.verou.me/css3patterns' }^ gallery
          with a lot of examples of these patterns
        %Header{ as: 'h4' } background-blend-mode
        %p
          More recently, browsers have started to support
          %code^ background-blend-mode
          as a way of combining CSS backgrounds (including gradients)
          in more interesting ways.
          %a{ href: 'http://bennettfeely.com' }^ Bennett Feely
          has published another
          %a{ href: 'http://bennettfeely.com/gradients/' }^ gallery
          of gradient patterns which all make use of the new
          %code^ background-blend-mode
          property
        %Header{ as: 'h4' } Sass mixins = customize!
        %p
          The patterns from these galleries demonstrate a lot of
          interesting possibilities but it can be tricky to tweak
          them in different ways (even if you're comfortable with CSS)
          since the gradient syntax can be verbose and repetitive
          (and there may be math involved)
        %p
          So I published <a href='http://github.com/helixbass/sass-gradient-patterns'>
            %code sass-gradient-patterns
          </a>,
          which collects all of the patterns from these two galleries
          (as well as some others) and provides a
          %a{ href: 'http://sass-lang.com' }^ Sass mixin
          for each one.
          By including
          %code^ sass-gradient-patterns
          in your project, you can easily use any of these patterns
          as-is or tweaked a little (or a lot) -
          the mixins allow you to pass a value for things like sizes,
          individual colors, angles, etc
          that will modify the pattern for you compared to the version
          found in the original pattern galleries.
        %Header{ as: 'h4', icon: 'configure', content: 'Customize interactively' }
        %p
          Using this page, you can choose any of the patterns
          (from the Pattern chooser)
          and then customize them in any of the ways supported by the
          underlying
          %code^ sass-gradient-patterns
          mixin library.
          Inside the Edit tab on the Customize pane,
          you can edit any parameter and you should see the
          resulting pattern show up as the page's background.
        %Header{ as: 'h4' } Export to your project
          Once you have a pattern you like, you can
          export the pattern to your own project by copying and
          pasting the code from the CSS tab (or from the SCSS tab,
          if you know how to set that up)
        %Message{ warning: yes }
          %p
            To get the CSS to work in your project, you'll have to
            change
            %code^ .selector
            to the appropriate CSS selector for the element on your
            page which you'd like to have the pattern background
        %Header{ as: 'h4', icon: 'save', content: 'Save it' }
        %p
          Or you can save your customized pattern for later by clicking Save.
        %Message{ warning: yes }
          %p
            Saving a pattern saves it to your browser's storage.
            So it'll only be saved for this browser on this computer
