# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :chats do
      primary_key :id
      column :chat_id, Integer, null: false, unique: true

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
