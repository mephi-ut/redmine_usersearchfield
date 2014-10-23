class UsersearchfieldController < ApplicationController
#	before_filter :authorize

	def autocomplete_for_user
		if params[:q].length > 0
			@users = User.all.active.sorted.like(params[:q]).limit(100).all
			render :layout => false
		else
			render_403
		end
	end
end
