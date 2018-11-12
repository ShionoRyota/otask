class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, # パスワードを暗号化してDBに登録
         :registerable, # ユーザーに自身のアカウントを編集したり削除することを許可
         :recoverable, # パスワードをリセットし、それを通知
         :rememberable, # 保存されたcookieから、ユーザーを記憶するためのトークンを生成・削除
         :trackable, # サインイン回数や、サインイン時間、IPアドレスを記録
         :validatable, # バリデーションを提供
         :confirmable, # メールに記載されているURLをクリックして本登録を完了する
         :lockable # 一定回数サインインを失敗するとアカウントをロック


  has_many :lists, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :expenditures, dependent: :destroy
  validates :company_name, presence: true
  validates :president_name, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
end
