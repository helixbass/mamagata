class ProjectsController < ApplicationController
  def gradients
  end

  def gradients_mixins_scss
    contents = File.read(Rails.root.join('..', 'sass-gradient-patterns', '_gradient_patterns.scss'))
    render json: {contents: contents}
  end

  def render_sass
    sass = params[:sass]
    return render json: {css: render_single_sass(sass)} if sass.is_a? String
    render json: {
      css:
        map_hash(sass.permit!.to_hash) do |single_sass|
          render_single_sass single_sass
        end
    }
  end

  private

  def map_hash hash
    Hash[
      hash.map do |key, val|
        [key, yield(val)]
      end
    ]
  end

  def render_single_sass sass
    engine = Sass::Engine.new(
      sass,
      syntax: :scss,
      load_paths: [Rails.root.join('..', 'sass-gradient-patterns')]
    )
    engine.render
  end
end
