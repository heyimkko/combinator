Combinator::Application.routes.draw do
  root to: "pages#landing"
  get "results" => "flights#results", :as => :results
end
