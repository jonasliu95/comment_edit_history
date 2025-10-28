module CommentEditHistory
  class JournalNoteVersion < ActiveRecord::Base
    self.table_name = 'comment_edit_history_journal_note_versions'

    belongs_to :journal, class_name: 'Journal'
    belongs_to :edited_by, class_name: 'User', optional: true

    validates :notes, presence: true
    validates :edited_at, presence: true

    scope :recent_first, -> { order(edited_at: :desc, created_at: :desc) }
  end
end
