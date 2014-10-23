module UserSearchField
	module CustomFieldsHelperPatch
		def self.included(base)
			base.extend(ClassMethods)
			base.send(:include, InstanceMethods)

			base.class_eval do
				alias_method_chain :edit_tag_style_tag, :usersearchfield
			end
		end

		module ClassMethods
		end

		module InstanceMethods
			def edit_tag_style_tag_with_usersearchfield(form, options={})
				select_options = [[l(:label_drop_down_list), ''], [l(:label_checkboxes), 'check_box'], [l(:label_searchedit), 'search']]
				if options[:include_radio]
					select_options << [l(:label_radio_buttons), 'radio']
				end
				form.select :edit_tag_style, select_options, :label => :label_display
			end
		end
	end
end

CustomFieldsHelper.send(:include, UserSearchField::CustomFieldsHelperPatch)

