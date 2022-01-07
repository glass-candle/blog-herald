# frozen_string_literal: true

module Application
  module Ports
    module Repositories
      class PostRepo < Core::Application::Ports::BaseRepository[:posts]
        commands :create, use: :timestamps, plugins_options: { timestamps: { timestamps: %i[created_at updated_at] } }

        # Returns an array of tuples unique to each chat with arrays
        # of ids of posts that the user should be notified about.
        def aggregate_relevant_by_chat_ids
          posts.read(<<~QUERY.chomp).to_a
            select result.chat_id, array_agg(result.post_id) as post_ids
            from (
              select posts.id as post_id, chats.id as chat_id
              from posts
              left join blogs on posts.blog_id = blogs.id
              left join chats_blogs on chats_blogs.blog_id = blogs.id
              left join chats on chats.id = chats_blogs.chat_id
              where posts.created_at > chats_blogs.created_at
              except select post_id, chat_id from chat_notifications
            ) as result
            group by chat_id;
          QUERY
        end

        def all_by_ids_with_blogs(post_ids)
          posts.combine(:blogs).where(id: post_ids).to_a
        end

        def create_posts(post_dtos, blog_id)
          create_changeset = posts
            .changeset(:create, post_dtos.map { |post_dto| { title: post_dto.title, link: post_dto.link, blog_id: blog_id } })
            .map(:add_timestamps)
          posts.command(:create, result: :many).call(create_changeset)
        end
      end
    end
  end
end
