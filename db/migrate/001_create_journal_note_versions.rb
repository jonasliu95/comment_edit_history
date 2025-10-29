class CreateJournalNoteVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_edit_history_journal_note_versions do |t|
      t.integer :journal_id, null: false
      t.integer :edited_by_id, null: true
      t.text :notes, null: false
      t.datetime :edited_at, null: false
      t.timestamps
    end

    add_index :comment_edit_history_journal_note_versions, :journal_id,
              name: :idx_ceh_journal_note_versions_journal
    add_index :comment_edit_history_journal_note_versions, :edited_by_id,
              name: :idx_ceh_journal_note_versions_editor

    add_foreign_key :comment_edit_history_journal_note_versions, :journals, column: :journal_id
    add_foreign_key :comment_edit_history_journal_note_versions, :users, column: :edited_by_id
  end
end
