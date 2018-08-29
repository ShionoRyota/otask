class UsersController < ApplicationController

	def index
		@login_user = User.find(current_user[:id])
	end


end
