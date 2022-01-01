# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :chats_blogs do
      primary_key :id
      foreign_key :chat_id, :chats
      foreign_key :blog_id, :blogs

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
