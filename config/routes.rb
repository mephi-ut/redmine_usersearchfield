RedmineApp::Application.routes.draw do
	get 'usersearchuserfield/autocomplete_for_user',		:to => 'usersearchfield#autocomplete_for_user'
end

