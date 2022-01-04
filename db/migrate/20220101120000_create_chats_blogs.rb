# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :chats_blogs do
      primary_key :id
      foreign_key :chat_id, :chats, on_delete: :cascade, null: false
      foreign_key :blog_id, :blogs, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index %i[chat_id blog_id], unique: true
    end
  end
end
