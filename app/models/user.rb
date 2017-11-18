class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_attached_file :profile_picture, default_url: "/system/images/:style/missing.png"
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\z/

  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes


  has_many :friendships
  has_many :friends, through: :friendships


  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  has_many :inverse_friends, through: :inverse_friendships, source: :user


  def get_all_friends
  	friend_ids = self.friends.all.pluck(:id)
  	inverse_friend_ids = self.inverse_friends.all.pluck(:id)
  	all_friends = friend_ids + inverse_friend_ids
  	return User.where('id in (?)', all_friends)

  end

  def get_all_non_friends

    all_friend_ids = self.get_all_friends.pluck(:id)

    return User.where('id not in (?)', all_friend_ids + [self.id])

  end

  def set_access_token
    self.access_token = SecureRandom.hex
    self.access_token_is_valid = true
  end

end












