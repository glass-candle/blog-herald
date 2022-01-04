# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :posts do
      primary_key :id
      column :title, String, null: false
      column :link, String, null: false
      foreign_key :blog_id, :blogs, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
