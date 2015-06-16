class DummyModel < ActiveRecord::Base
  acts_as_commentable :delivery_man, :comments
end
