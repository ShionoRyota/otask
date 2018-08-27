class UsersController < ApplicationController

	def index
		@login_user = User.find(current_user[:id])
	end

	def my_page
	  @conpanies = current_user.conpanies
    end

end
