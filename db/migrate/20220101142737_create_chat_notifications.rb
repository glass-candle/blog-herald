# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :chat_notifications do
      primary_key :id
      foreign_key :chat_id, :chats, on_delete: :cascade, null: false
      foreign_key :post_id, :posts, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
