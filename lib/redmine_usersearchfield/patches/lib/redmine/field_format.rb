
module UserSearchField
	module FieldFormatListPatch
		def self.included(base)
			base.extend(ClassMethods)
			base.send(:include, InstanceMethods)

			base.class_eval do
				alias_method_chain :edit_tag, :usersearchfield
			end
		end

		module ClassMethods
		end

		module InstanceMethods
			def edit_tag_with_usersearchfield(view, tag_id, tag_name, custom_value, options={})
				if custom_value.custom_field.edit_tag_style == 'search'
					Rails.logger.info(tag_name.to_yaml)
					return search_edit_tag(view, tag_id, tag_name, custom_value, options)
				end
				return edit_tag_without_usersearchfield(view, tag_id, tag_name, custom_value, options)
			end


			protected

			def search_edit_tag(view, tag_id, tag_name, custom_value, options={})
				custom_field = custom_value.custom_field

				tag =  view.text_field_tag "cf_#{tag_id}_search_ac", nil
				tag << ' '
				tag << view.link_to_function(l(:label_cancel), "$('#cf_#{tag_id}_search_ac').val(''); $('##{tag_id}').html($('##{tag_id}_cancel_content').html()); $('##{tag_id}').attr('size', 1); return false;")
				tag << view.tag(:br)

				blank = custom_field.is_required? ?
				((custom_field.default_value.blank? && custom_value.value.blank?) ? view.content_tag(:option, "--- #{l(:actionview_instancetag_blank_option)} ---") : ''.html_safe) :
					view.content_tag(:option)

				options_tags = blank + view.options_for_select(custom_field.possible_values_options(custom_value.customized), custom_value.custom_field.multiple? ? nil : custom_value.value)

				case custom_field.type
					when 'IssueCustomField'
						issue = custom_value.customized
						addcmd = "updateIssueFrom('#{view.escape_javascript view.project_issue_form_path(issue.project, :id => issue, :format => 'js')}');"
					else
						addcmd = ''
				end

				div_content = view.tag(:span)
				if custom_value.custom_field.multiple?
					users_list = view.tag(:span)
					custom_value.value.each do |uid|
						next if uid.nil?
						next if uid == ''

						user = User.find(uid)
						next if user.nil?

						user_entry = view.link_to_function(user.name, "var e = document.getElementById('#{tag_id}_set_#{uid}_entry'); e.parentNode.removeChild(e);", :class => 'icon-del usersearchfield_deluser_entry')
#						user_entry << custom_value.customized.to_yaml
						user_entry << view.hidden_field_tag(tag_name, uid)

						users_list << view.content_tag(:li, user_entry, :id => "#{tag_id}_set_#{uid}_entry")
					end

					div_content << view.content_tag(:ul, users_list, :style => 'padding: 0; list-style-type: none')
				end

				div_content << view.select_tag(tag_name, options_tags, options.merge(:id => tag_id, :multiple => custom_value.custom_field.multiple?, :class => "usersearchselect"))

				div_content << view.content_tag(:span,  options_tags, id: "#{tag_id}_cancel_content", style: 'display:none')
				if custom_value.custom_field.multiple?
					div_content << ' '
					div_content << view.link_to_function(l(:label_add), "#{addcmd}; $('##{tag_id}').val([]);")
				end

				div_content << view.javascript_tag("
					observeSearchfield('cf_#{tag_id}_search_ac', '#{tag_id}',
						'#{
							view.escape_javascript view.url_for(
								:controller     => 'usersearchfield',
								:action         => 'autocomplete_for_user',
								:selected       => custom_value.value,
								:field_id       => tag_id
							)
						}'
					)
				")

				if custom_value.custom_field.multiple?
					tag << view.content_tag(:div, div_content, :style => 'display: inline-block; margin-left: 180px')
				end
			end
		end
	end
end

Redmine::FieldFormat::List.send(:include, UserSearchField::FieldFormatListPatch)

