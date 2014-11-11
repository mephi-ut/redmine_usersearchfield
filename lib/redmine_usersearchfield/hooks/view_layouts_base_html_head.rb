module UserSearchField
        class Hooks < Redmine::Hook::ViewListener
                render_on :view_layouts_base_html_head, :partial => 'layouts/redmine_usersearchfield_css'
        end
end
