class ProjectsController < ApplicationController
  def gradients
  end

  def gradients_mixins_scss
    contents = File.read(Rails.root.join('..', 'sass-gradient-patterns', '_gradient_patterns.scss'))
    render json: {contents: contents}
  end

  def render_sass
    sass = params[:sass]
    engine = Sass::Engine.new(
      sass,
      syntax: :scss,
      load_paths: [Rails.root.join('..', 'sass-gradient-patterns')]
    )
    css = engine.render
    render json: {css: css}
  end
end
