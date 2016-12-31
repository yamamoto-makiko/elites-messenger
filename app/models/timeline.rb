class Timeline < ActiveRecord::Base
  belongs_to :user
  #--************************* 下記を追加 ************************  
  # has_many   :replies, class_name: 'Timeline', foreign_key: 'reply_id'
  has_many :replies, class_name: 'Timeline', foreign_key: 'reply_id', dependent: :destroy
  #--*************************************************************
  validates :message, presence: true, allow_blank: false
  scope :user_filter, -> user_id do
    # user_idパラメータがあればフィルターをかける
    where(user_id: user_id) if user_id.present?
  end
  #--************************* 下記を追加 ************************
  scope :not_reply, ->  do
    # 返信でないデータを取得
    where(reply_id: nil)
  end
  #--*************************************************************
end
