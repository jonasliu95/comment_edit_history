module CommentEditHistory
  module Hooks
    class ViewIssuesHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(_context = {})
        javascript_include_tag('comment_edit_history', plugin: 'comment_edit_history') +
          stylesheet_link_tag('comment_edit_history', plugin: 'comment_edit_history')
      end

      def view_issues_history_journal_bottom(context = {})
        controller = context[:controller]
        journal = context[:journal]
        return unless controller && journal && journal.respond_to?(:note_versions)

        controller.send(:render_to_string,
                        partial: 'comment_edit_history/history',
                        locals: { journal: journal })
      end
    end
  end
end
