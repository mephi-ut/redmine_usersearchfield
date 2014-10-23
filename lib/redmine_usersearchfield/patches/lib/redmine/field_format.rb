
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
					return search_edit_tag(view, tag_id, tag_name, custom_value, options)
				end
				return edit_tag_without_usersearchfield
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

				options_tags = blank + view.options_for_select(custom_field.possible_values_options(custom_value.customized), custom_value.value)

		#                tag << select_tag(field_name, select_tag_content, :id => field_id, :class => field_class)
				tag << view.select_tag(tag_name, options_tags, options.merge(:id => tag_id, :multiple => custom_value.custom_field.multiple?))
				if custom_value.custom_field.multiple?
					s << view.hidden_field_tag(tag_name, '')
				end
				tag << view.content_tag(:span,  options_tags, id: "#{tag_id}_cancel_content", style: 'display:none')

				tag << view.javascript_tag("
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
			end
		end
	end
end

Redmine::FieldFormat::List.send(:include, UserSearchField::FieldFormatListPatch)

