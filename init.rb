require 'redmine'

require_dependency 'redmine_usersearchfield/hooks/view_layouts_base_html_head'

require_dependency "redmine_usersearchfield/patches/app/helpers/custom_fields_helper"
require_dependency "redmine_usersearchfield/patches/lib/redmine/field_format"
	
Redmine::Plugin.register :redmine_usersearchfield do
    name 'User search field plugin'
    author 'Dmitry Yu Okunev'
    author_url 'https://github.com/xaionaro/'
    description 'Adds a display type for custom fields that adds a search field for users'
    url 'https://github.com/mephi-ut/redmine_usersearchfield'
    version '0.0.1'
end
