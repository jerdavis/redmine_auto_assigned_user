module AutoAssignedUser
  class Hooks < Redmine::Hook::ViewListener

      def controller_issues_new_before_save(context)
        autoset_user(context)
      end

      def controller_issues_edit_before_save(context)
        autoset_user(context)
      end

      def autoset_user(context)
        @settings ||= Setting.plugin_redmine_auto_assigned_user
        if context[:params][:issue]
          if context[:params][:issue][:assigned_to_id].blank?
            users_list = context[:issue].project.users_by_role
            manager_role = Role.find(@settings['project_manager_role'].to_i)
            context[:issue].assigned_to_id = users_list[manager_role].first.id unless users_list[manager_role].blank?
          end
        end
      end
  end
end
