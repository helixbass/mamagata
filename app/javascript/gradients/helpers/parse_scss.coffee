import gonzales from 'gonzales-pe'

export default ->
  fetch '/projects/gradients_mixins_scss'
  .then (response) ->
    response.json()
  .then ({contents}) ->
    gonzales.parse contents, syntax: 'scss'
  .then (ast) ->
    console.log {ast}
    mixins: do ->
      parse_comment = (comment) ->
        if match = ///
          ^
          /
          \s +
          @link
          \s +
          (. +) # url
        ///.exec comment
          [all, url] = match
          return current_mixin.source_url = url

        return unless match = ///
          ^
          /
          \s +
          @param
          \s +
          {(\w +)} # type
          \s +
          \$([\w-]+) # name
          \s +
          \[
          (?:
            ([^\]\(] +) # normal default
            |
            [^\]] +
            \(
            ([^\(\)] +) # dynamic default
            \)
          )
          \]
        ///.exec comment
        [all, type, name, normal_default, dynamic_default] = match
        (current_mixin.params ?= [])
        .unshift {type, name, default: normal_default ? dynamic_default}
      mixins = {}
      current_mixin = null
      ast.eachFor (node) ->
        {type, content} = node
        switch type
          when 'mixin'
            mixin_name = node.first('ident').content
            current_mixin = mixins[mixin_name] = name: mixin_name
          when 'singlelineComment'
            parse_comment content
      mixins
