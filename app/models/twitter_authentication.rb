class TwitterAuthentication < ActiveRecord::Base
  attr_accessible :secret, :token, :uid, :user_id
  belongs_to :user
end
