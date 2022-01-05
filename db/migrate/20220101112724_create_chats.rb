# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :chats do
      primary_key :id
      column :chat_uid, String, null: false, unique: true

      column :created_at, 'timestamp with time zone', null: false
      column :updated_at, 'timestamp with time zone', null: false
    end
  end
end
