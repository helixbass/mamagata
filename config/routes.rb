Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'projects/gradients'
  get 'projects/gradients_mixins_scss'
  get 'projects/render_sass'
  get 'projects/jsxy'

  root to: 'main#home'
end
