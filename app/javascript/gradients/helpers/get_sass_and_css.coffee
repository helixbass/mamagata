import axios from 'axios'
import fromPairs from 'lodash/fromPairs'

export default ({mixin, mixin_args}) ->
  default_values =
    fromPairs([name, _default] for {default: _default, name} in mixin.params)
  default_value = (name) ->
    default_values[name]
  non_default_args =
    {name, value} for {name, value} in mixin_args when value isnt default_value name

  sass = """
    @import 'gradient_patterns';

    .app {
        @include #{mixin.name}#{
          if non_default_args.length
            "(#{
              (for {name, value} in non_default_args
                "$#{name}: #{value}"
              ).join ', '
            })"
          else ''
        };
    }
  """
  axios.get '/projects/render_sass',
    params: {sass}
  .then ({data}) -> data
  .then ({css}) ->
    {sass, css}
