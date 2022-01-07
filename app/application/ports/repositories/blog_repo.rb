# frozen_string_literal: true

module Application
  module Ports
    module Repositories
      class BlogRepo < Core::Application::Ports::BaseRepository[:blogs]
        commands :create, use: :timestamps, plugins_options: { timestamps: { timestamps: %i[created_at updated_at] } }

        def upsert(blog_dtos)
          blog_dtos.map do |blog|
            blogs.upsert({ codename: blog.codename, title: blog.title, link: blog.link, created_at: Time.now.utc, updated_at: Time.now.utc })
          end
        end

        def delete_by_codenames(codenames)
          blogs.where(codename: codenames).delete
        end

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

        def with_posts(id)
          blogs.combine(:posts).where(id: id).one
        end
      end
    end
  end
end
