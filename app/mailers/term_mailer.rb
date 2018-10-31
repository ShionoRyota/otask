class TermMailer < ApplicationMailer
  def send_when_redline(user,task,list)
    @user = user
    @task = task
    @list = list
    mail to:      user.email,
         subject: '納期が来ました'
  end

  def send_when_yellowline(user,task,list)
    @user = user
    @task = task
    @list = list
    mail to:      user.email,
         subject: '納期がもうすぐです'
  end
end
