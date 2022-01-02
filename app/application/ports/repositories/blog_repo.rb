# frozen_string_literal: true

module Application
  module Ports
    module Repositories
      class BlogRepo < Core::Application::Ports::BaseRepository[:blogs]
        commands :create, use: :timestamps, plugins_options: { timestamps: { timestamps: %i[created_at updated_at] } }

        def by_codename(codename)
          blogs.where(codename: codename).limit(1).one
        end

        def all_with_subscription_status(chat_uid)
          blogs
            .select(:id, :codename, :title, :link, :created_at, :updated_at)
            .select_append do |chats_blogs:|
              exists(
                chats_blogs
                  .left_join(:chats)
                  .where(relations[:chats][:chat_uid] => chat_uid, chats_blogs[:blog_id] => id)
              ).as(:subscribed)
            end
            .order(:title)
            .to_a
        end
      end
    end
  end
end
