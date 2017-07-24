import axios from 'axios'

export default ({mixin, mixin_args}) ->
  sass = """
    @import 'gradient_patterns';

    .app {
        @include #{mixin.name}(#{
          (for {name, value} in mixin_args
            "$#{name}: #{value}"
          ).join ', '
        });
    }
  """
  axios.get '/projects/render_sass',
    params: {sass}
  .then ({data}) -> data
  .then ({css}) ->
    {sass, css}
