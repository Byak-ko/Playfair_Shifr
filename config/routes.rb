Rails.application.routes.draw do
  root "cipher#index"
  post "cipher/encrypt"
  post "cipher/decrypt"
end
