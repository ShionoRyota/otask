
# 一定時間ごとに納期がすぎてないかチェックする
namespace :check_date do
	desc "check_state"
	task :check_state => :environment do
		tasks = Task.all
        @tasks = tasks.each{ |tasks|
          @tas = tasks.term
          @task = tasks.taskname
          @time = (@tas - Time.new.to_time)
          @user = User.find_by(id: tasks.user_id)
          @list = List.find_by(id: tasks.list_id)
            if @time <= 0 && tasks.flag_id == 0 || @time <= 0 && tasks.flag_id == 1
              tasks.update(color_id: 2)
              TermMailer.send_when_redline(@user,@task,@list).deliver
            elsif 0 < @time && @time <= 604800 && tasks.flag_id == 0 || 0 < @time && @time <= 604800 && tasks.flag_id == 1
              tasks.update(color_id: 1)
              TermMailer.send_when_yellowline(@user,@task,@list).deliver
            end
        }
    end
end
