module CommentEditHistory
  module Patches
    module JournalPatch
      extend ActiveSupport::Concern

      included do
        has_many :note_versions,
                 -> { order(edited_at: :desc, created_at: :desc) },
                 class_name: 'CommentEditHistory::JournalNoteVersion',
                 foreign_key: :journal_id,
                 dependent: :destroy,
                 inverse_of: :journal

        after_update :store_previous_note_version
      end

      private

      def store_previous_note_version
        return unless notes_changed_for_history?

        previous_note = previous_note_for_history
        current_note = self[:notes]
        return if previous_note.blank?
        return if previous_note == current_note

        Rails.logger.debug { "[CommentEditHistory] Captured edit for journal ##{id}" }

        note_versions.create!(
          notes: previous_note,
          edited_by: editor_for_history,
          edited_at: editor_timestamp
        )
      rescue => e
        Rails.logger.error { "[CommentEditHistory] Failed to persist history for journal ##{id}: #{e.class} - #{e.message}" }
      end

      def notes_changed_for_history?
        if respond_to?(:saved_change_to_attribute?)
          saved_change_to_attribute?(:notes)
        elsif respond_to?(:saved_change_to_notes?)
          saved_change_to_notes?
        elsif respond_to?(:will_save_change_to_attribute?)
          will_save_change_to_attribute?(:notes)
        elsif respond_to?(:notes_changed?)
          notes_changed?
        else
          false
        end
      end

      def previous_note_for_history
        if respond_to?(:attribute_before_last_save)
          attribute_before_last_save('notes')
        elsif respond_to?(:notes_before_last_save)
          notes_before_last_save
        elsif respond_to?(:attribute_in_database)
          attribute_in_database('notes')
        elsif respond_to?(:notes_was)
          notes_was
        else
          self[:notes]
        end
      end

      def editor_for_history
        return nil unless User.current&.logged?

        User.current
      end

      def editor_timestamp
        if respond_to?(:updated_on) && updated_on.present?
          updated_on
        else
          Time.current
        end
      end

    end
  end
end
