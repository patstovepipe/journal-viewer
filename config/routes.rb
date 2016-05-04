Rails.application.routes.draw do
  get 'journal/index' 
  get '/search' => 'journal#search'

  get '/journalctl' => 'journal#journalctl'

  root 'journal#index'

end
