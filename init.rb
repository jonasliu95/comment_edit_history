require 'redmine'

Redmine::Plugin.register :comment_edit_history do
  name 'Comment Edit History'
  author 'Jonas Liubinas'
  description 'Keeps a visible history of edits made to issue comments.'
  version '0.1.0'
  url 'https://github.com/jonasliu95/comment_edit_history'
  author_url 'https://github.com/jonasliu95'
  requires_redmine version_or_higher: '6.0.0'
end

require_dependency 'journal'
require_dependency File.expand_path('lib/comment_edit_history/patches/journal_patch', __dir__)

unless Journal.included_modules.include?(CommentEditHistory::Patches::JournalPatch)
  Rails.logger.info('[CommentEditHistory] Including JournalPatch into Journal')
  Journal.send(:include, CommentEditHistory::Patches::JournalPatch)
else
  Rails.logger.debug('[CommentEditHistory] JournalPatch already included')
end

require_dependency File.expand_path('lib/comment_edit_history/hooks/view_issues_hook', __dir__)
