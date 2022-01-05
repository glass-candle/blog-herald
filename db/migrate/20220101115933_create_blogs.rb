# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :blogs do
      primary_key :id
      column :codename, String, null: false, unique: true
      column :title, String, null: false
      column :link, String, null: false

      column :created_at, 'timestamp with time zone', null: false
      column :updated_at, 'timestamp with time zone', null: false
    end
  end
end
