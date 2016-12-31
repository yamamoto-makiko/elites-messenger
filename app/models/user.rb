class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # サムネイル画像にCarrierWaveで作成したUserThumbnailUploaderを使用
  mount_uploader :thumbnail, UserThumbnailUploader
  # バリデーションを設定
  validates :name, presence: true
  validates :agreement, presence: true, acceptance: {accept: true}
end
