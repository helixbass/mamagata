import {Modal, Header, Button, Message, List} from 'semantic-ui-react'
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
            %code^ .SELECTOR
            to the appropriate CSS selector for the element on your
            page which you'd like to have the pattern background
        %Header{ as: 'h4', icon: 'save', content: 'Save it' }
        %p
          Or you can save your customized pattern for later by clicking Save.
          This will also save animations (see below).
        %Message{ warning: yes }
          %p
            Saving a pattern saves it to your browser's storage.
            So it'll only be saved for this browser on this computer
        %Header{ as: 'h4', icon: 'video play', content: 'Animate' }
        %p
          In addition to customizing the patterns, you can animate them via the
          Animate pane.
          Under the Edit tab, there are two sections:
        %List{ bulleted: yes }
          %List.Item controls for animation playback and looping
          %List.Item the steps of your animation
        %Header{ as: 'h4', content: 'Baby steps' }
        %p
          To get started, under Step 1, click "Add animated param" and choose which aspect of the pattern
          you'd like to animate. Then edit its value, click play and the background should smoothly loop
          back and forth a few times between your starting pattern and the pattern with this new modified value.
        %Header{ as: 'h4', content: 'Animated plaid' }
        %p
          For example, open the Gingham pattern and click Animate to open the Animate pane.
          The Edit tab should be open, so you should see animation playback controls followed by an expanded Step 1.
          Click "Add animated param" under Step 1 and choose "Color width" from the dropdown list that appears.
          An editable Color width field should appear. Change its value from 50% to 20%.
          Then try running the animation by clicking play.
          The red plaid stripes should animate a couple times between their initial size and a thinner style.
        %Header{ as: 'h4', content: 'Previewing animation steps' }
        %p
          Say that 20% doesn't look quite right. Rather than guessing a couple times and re-running the animation each
          time, you can check "Preview?" (under Step 1) and the end result of Step 1 should show up as the background.
          Try editing the 20% a couple times and see what you like - the background should update as you edit.
          Then when you click play the animation should loop between its original start value and your newly chosen value.
        %Header{ as: 'h4', content: 'Controlling animation speed' }
        %p
          Say that you want the animation to run more slowly.
          Change the Duration value (under Step 1) from 400 to 1500 (aka 1.5 seconds).
          Then click play again and the animation should run slower.
        %p
          You can also play around with the different Easing choices (below Duration),
          which affect the animation's acceleration throughout the specified duration
          (eg easeIn easings will start slowly and then pick up speed)
        %Header{ as: 'h4', content: 'Additional params' }
        %p
          Continuing our example, if you also choose Color from "Add animated param" and pick a different color
          from the color picker that shows up, then when you click play the red plaid stripes should also change color
          as they shrink.
        %Header{ as: 'h4', content: 'Multiple steps' }
        %p
          But say that what you were picturing is that the color would change <em>after</em> the stripes shrink.
          Then we need two different steps to our animation.
          So click the X at the right side of the Color field (this should leave only Color width under Step 1).
          Then click Add step (to the right of Step 1).
          This should open up Step 2. Under Step 2, choose Color from "Add animated param" and
          pick your color from the color picker like before.
          Now if you click play, for each loop you should see the stripes shrink, their color change, and then
          as the animation loops back the color changes back and the stripes expand back.
          If the timing seems off, you can play with the duration/easing of each step separately.
        %Header{ as: 'h4', content: 'Single playback' }
        %p
          If you just want the animation to run once from your start pattern through your animation steps,
          uncheck "Loop?" (under the play button).
          Now when you click play, the stripes should shrink, then the color change, and stop.
        %Header{ as: 'h4', content: 'Overlapping steps' }
        %p
          Say that now what you really picture is the color gradually changing while the stripes first shrink
          and then expand to thicker than their original width.
        %p
          First, let's make our color-changing step come first by clicking the little up-and-down arrows to the
          right of "Preview?" under Step 2 and choosing Before Step 1 from the "Move to:" dropdown
          (you can also delete animation steps using the X next to the up-and-down arrows).
          This swaps our steps: now the color change is Step 1 and the color width is Step 2.
        %p
          Next, change the duration of Step 1 (the color change) to something big, say 2000.
          Then under Step 2, click on "when the previous step ends" to edit it to 2000 ms before the previous step ends.
          Edit our Step 2 duration to be half of Step 1 duration, so 1000.
          If we run our animation now (with Loop unchecked), the color should start fading while the stripes are
          shrinking and then finish fading after the stripes are done.
        %p
          Finally, click "Add step" to create Step 3. Under Step 3, click "Add animated param", choose Color width,
          and edit to 65%. Set Step 3's Duration to 1000.
          Now playing the animation should have the desired progression: the color gradually changes while the stripes
          first shrink and then expand past their original size.
        %Message{ warning: yes }
          %p
            While this enables most of the possibilities for crafting your animations,
            there are always more options when you are working directly in Javascript.
            So whether you use exported JS (see below) from this tool as a starting point
            or just start from scratch, writing code allows you to tap more directly into
            the capabilities of the underlying animation engine and language
        %Header{ as: 'h4', content: 'Export your animation' }
        %p
          Once you're satisfied with your animation, you can
          export it to your own project by copying and
          pasting the code from the Export JS tab.
        %p
          Under the JS animation code, there are links to instructions
          for how to load the necessary animation libraries into your project.
        %p
          You'll also want to export the CSS from the Customize pane since it specifies
          the starting point of your animation.
        %Message{ warning: yes }
          %p
            To get the Javascript to work in your project, you'll have to
            change
            %code^ .SELECTOR
            to the appropriate CSS selector for the element on your
            page which you'd like to animate
        %Message{ warning: yes }
          %p
            This page currently only exports animation code for AnimeJS.
            If you're using jQuery, you can compare equivalent AnimeJS vs jQuery code
            in the examples <a href='/projects/animate_backgrounds'>here</a>,
            or check back soon for export jQuery support 
        %Header{ as: 'h4', content: 'Under the hood' }
        %p
          The animations use <a href='/projects/animate_backgrounds'><code>animate-backgrounds</code></a>,
          a package which enables animating CSS
          %code^ background-image
          gradients, <code>background-position</code>, and <code>background-size</code> in either
          jQuery or a
          %a{ href: 'npm.im/animejs-hooks' }^ hook-enabled version
          of AnimeJS (this page currently only uses/exposes the AnimeJS version).
        %p
          If you're curious about how this page works, you can check out the source code in the
          %a{ href: 'https://github.com/helixbass/mamagata' }^ helixbass/mamagata
          repo (most of the (React/Redux) code for this page is under <code>app/javascript/gradients/</code>)
