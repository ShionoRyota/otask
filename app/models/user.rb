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
         :lockable, # 一定回数サインインを失敗するとアカウントをロック
         :timeoutable

  has_many :lists, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :expenditures, dependent: :destroy
  validates :company_name, presence: true
  validates :president_name, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true
  validate :password_complexity


  def postal_code=(value)
    value.tr!('/[０-９ー]/', '/[0-9-]/') if value.is_a?(String)
    super(value)
  end

  def phone_number=(value)
    value.tr!('/[０-９ー]/', '/[0-9-]/') if value.is_a?(String)
    super(value)
  end

  def fax_number=(value)
    value.tr!('/[０-９ー]/', '/[0-9-]/') if value.is_a?(String)
    super(value)
  end


 def password_complexity
  return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,70}$/
  errors.add :password, "パスワードの強度が不足しています。パスワードの長さは8〜70文字とし、大文字と小文字と数字をそれぞれ1文字以上含める必要があります。"
 end

end
