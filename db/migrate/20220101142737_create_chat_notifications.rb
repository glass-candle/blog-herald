# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :chat_notifications do
      primary_key :id
      foreign_key :chat_id, :chats
      foreign_key :post_id, :posts

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
