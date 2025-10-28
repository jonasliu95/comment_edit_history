# Comment Edit History

Redmine plugin that keeps an audit trail of edited issue comments and exposes the previous revisions directly in the issue history.

Tested with Redmine 6.1 bookworm

## Features

- Captures every change made to the notes of an issue journal entry.
- Stores the full text of each revision alongside the editor and timestamp.
- Adds a toggleable panel under each updated comment so all users can review the prior versions.

## Screenshot

![Comment Edit History Example](example.png)

## Installation

1. Copy the plugin into `plugins/comment_edit_history`.
2. Run the plugin migrations:

   ```bash
   bundle exec rake redmine:plugins:migrate NAME=comment_edit_history RAILS_ENV=production
   ```

3. Precompile/refresh the plugin assets (optional in development, required in production):

   ```bash
   bundle exec rake assets:precompile NAME=comment_edit_history RAILS_ENV=production
   ```

4. Restart Redmine.

## Usage

Once installed, edit any issue comment. A “Show comment edit history” link appears beneath the entry, exposing all recorded revisions.

The revision is only visible after page refresh.

## Localization

| Locale | Status        |
|--------|----------------|
| en     | Full support   |
| lt     | Full support   |
| de     | Not supported  |
| es     | Not supported  |
| fr     | Not supported  |
| it     | Not supported  |
| ja     | Not supported  |
| ru     | Not supported  |

## Credits

- Concept, development, and ongoing maintenance: **Jonas Liubinas**