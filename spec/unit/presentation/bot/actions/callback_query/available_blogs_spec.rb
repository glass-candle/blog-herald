RSpec.describe Presentation::Bot::Actions::CallbackQuery::AvailableBlogs, type: :unit_test do
  subject do
    described_class.new(
      opt_in_status: opt_in_status,
      list_blog_statuses: list_blog_statuses,
      subscription_blog_list: subscription_blog_list,
      blog_list: blog_list,
      paged_blog_list_navigation: paged_blog_list_navigation,
      blog_list_navigation: blog_list_navigation
    )
  end

  include Dry::Effects::Handler::Reader(:bot_adapter)

  let(:opt_in_status) { instance_double('Application::Operations::Chat::OptInStatus') }
  let(:list_blog_statuses) { instance_double('Application::Operations::Chat::ListBlogStatuses') }
  let(:subscription_blog_list) { instance_double('Presentation::Bot::Responses::Text::SubscriptionBlogList') }
  let(:blog_list) { instance_double('Presentation::Bot::Responses::Text::BlogList') }
  let(:paged_blog_list_navigation) { instance_double('Presentation::Bot::Responses::ReplyMarkup::PagedBlogListNavigation') }
  let(:blog_list_navigation) { instance_double('Presentation::Bot::Responses::ReplyMarkup::BlogListNavigation') }

  let(:bot_adapter) { instance_double('BotAdapter') }

  let(:chat_id) { '123456' }
  let(:message_id) { '123' }
  let(:path) { 'available_blogs:1' }

  let(:blogs) do
    [
      Domain::Entities::Blog.new(codename: 'blog_a', title: 'blog_a', link: 'link_a'),
      Domain::Entities::Blog.new(codename: 'blog_b', title: 'blog_b', link: 'link_b'),
      Domain::Entities::Blog.new(codename: 'blog_c', title: 'blog_c', link: 'link_c'),
      Domain::Entities::Blog.new(codename: 'blog_d', title: 'blog_d', link: 'link_d'),
      Domain::Entities::Blog.new(codename: 'blog_e', title: 'blog_e', link: 'link_e'),
      Domain::Entities::Blog.new(codename: 'blog_f', title: 'blog_f', link: 'link_f')
    ]
  end

  describe 'with all operations successful' do
    before do
      allow(bot_adapter).to receive(:edit_message_text).with(
        chat_id: chat_id,
        message_id: message_id,
        parse_mode: 'markdown',
        disable_web_page_preview: true,
        text: text,
        reply_markup: reply_markup
      ).and_return(Dry::Monads::Result::Success.new(:ok))
    end

    context 'when opted in' do
      let(:text) { double }
      let(:reply_markup) { double }

      before do
        allow(opt_in_status).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(true))
        allow(list_blog_statuses).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(blogs))
        allow(subscription_blog_list).to receive(:render).with(hash_including(only_subscribed: false)).and_return(text)
        allow(paged_blog_list_navigation).to receive(:render).with(
          hash_including(
            path: path,
            current_page: 1,
            total_pages: 1
          )
        ).and_return(reply_markup)
      end

      it 'edits the message data' do
        with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id, path) }

        expect(bot_adapter).to have_received(:edit_message_text)
      end

      it 'returns a success' do
        result = with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id, path) }

        expect(result).to be_success
        expect(result.value!).to eq(:ok)
      end
    end

    context 'when opted out' do
      let(:text) { double }
      let(:reply_markup) { double }

      before do
        allow(opt_in_status).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(false))
        allow(list_blog_statuses).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(blogs))
        allow(blog_list).to receive(:render).with(blogs: blogs).and_return(text)
        allow(blog_list_navigation).to receive(:render).with(no_args).and_return(reply_markup)
      end

      it 'edits the message data' do
        with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id, path) }

        expect(bot_adapter).to have_received(:edit_message_text)
      end

      it 'returns a success' do
        result = with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id, path) }

        expect(result).to be_success
        expect(result.value!).to eq(:ok)
      end
    end
  end

  describe 'with a failed operation' do
    before do
      allow(opt_in_status).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(true))
      allow(list_blog_statuses).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Failure.new(:not_ok))
    end

    it 'returns a failure' do
      result = with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id, path) }

      expect(result).to_not be_success
      expect(result.failure).to eq(:not_ok)
    end
  end
end
