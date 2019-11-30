class Post < ActiveHash::Base
  self.data = [
    {:id => 1, :name => "piyo"},
    {:id => 2, :name => "fuga"}
  ]
end
