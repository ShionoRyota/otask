class TermMailer < ApplicationMailer

# 納期を過ぎた場合
  def send_when_redline(user,task,list)
    @user = user
    @task = task
    @list = list
    mail to:      user.email,
         subject: '納期が来ました'
  end

# 納期が1週間後いないの場合
  def send_when_yellowline(user,task,list)
    @user = user
    @task = task
    @list = list
    mail to:      user.email,
         subject: '納期がもうすぐです'
  end
end
