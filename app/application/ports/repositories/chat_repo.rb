# frozen_string_literal: true

module Application
  module Ports
    module Repositories
      class ChatRepo < Core::Application::Ports::BaseRepository[:chats]
        def by_chat_uid(chat_uid)
          chats.where(chat_uid: chat_uid).limit(1).one
        end

        def with_blogs(id)
          chats.combine(:blogs).by_pk(id).one
        end

        def subscription_exists?(chat_uid, blog_codename)
          chat = chats.combine(:blogs).where(chat_uid: chat_uid).limit(1).one
          !chat.blogs.find { |blog| blog.codename == blog_codename }.nil?
        end

        def create_with_blogs(chat_uid, blogs)
          chats.transaction do
            chat = chats
              .changeset(:create, chat_uid: chat_uid)
              .map(:add_timestamps)
              .commit

            join_table_changeset = chats_blogs
              .changeset(:create, blogs.map { |blog| { blog_id: blog.id, chat_id: chat.id } })
              .map(:add_timestamps)
            chats_blogs.command(:create, result: :many).call(join_table_changeset)

            chat
          end
        end

        def delete_by_chat_uid(chat_uid)
          chats.where(chat_uid: chat_uid).delete
        end

        def subscribe_to_blog(chat, blog)
          chats_blogs
            .changeset(:create, { blog_id: blog.id, chat_id: chat.id })
            .map(:add_timestamps)
            .commit
        end

        def unsubscribe_from_blog(chat, blog)
          chats_blogs.where(chat_id: chat.id, blog_id: blog.id).delete
        end
      end
    end
  end
end
