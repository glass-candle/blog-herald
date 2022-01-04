RSpec.describe Presentation::Bot::Actions::CallbackQuery::EnabledBlogs, type: :unit_test do
  subject do
    described_class.new(
      list_subscribed_blogs: list_subscribed_blogs,
      subscription_blog_list: subscription_blog_list,
      paged_blog_list_navigation: paged_blog_list_navigation
    )
  end

  include Dry::Effects::Handler::Reader(:bot_adapter)

  let(:list_subscribed_blogs) { instance_double('Application::Operations::Chat::ListSubscribedBlogs') }
  let(:subscription_blog_list) { instance_double('Presentation::Bot::Responses::Text::SubscriptionBlogList') }
  let(:paged_blog_list_navigation) { instance_double('Presentation::Bot::Responses::ReplyMarkup::PagedBlogListNavigation') }

  let(:bot_adapter) { instance_double('BotAdapter') }

  let(:chat_id) { '123456' }
  let(:message_id) { '123' }
  let(:path) { 'enabled_blogs:1' }

  let!(:blog_struct) { Struct.new(:codename, :title, :link, :subscribed) }
  let(:blogs) do
    [
      blog_struct.new(codename: 'blog_a', title: 'blog_a', link: 'link_a', subscribed: true),
      blog_struct.new(codename: 'blog_b', title: 'blog_b', link: 'link_b', subscribed: true),
      blog_struct.new(codename: 'blog_c', title: 'blog_c', link: 'link_c', subscribed: true),
      blog_struct.new(codename: 'blog_d', title: 'blog_d', link: 'link_d', subscribed: true),
      blog_struct.new(codename: 'blog_e', title: 'blog_e', link: 'link_e', subscribed: true),
      blog_struct.new(codename: 'blog_f', title: 'blog_f', link: 'link_f', subscribed: true)
    ]
  end

  describe 'with all operations successful' do
    let(:text) { double }
    let(:reply_markup) { double }

    before do
      allow(bot_adapter).to receive(:edit_message_text).with(
        chat_id: chat_id,
        message_id: message_id,
        disable_web_page_preview: true,
        text: text,
        reply_markup: reply_markup
      ).and_return(Dry::Monads::Result::Success.new(:ok))

      allow(list_subscribed_blogs).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(blogs))
      allow(subscription_blog_list).to receive(:render).with(hash_including(only_subscribed: true)).and_return(text)
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

  describe 'with a failed operation' do
    before do
      allow(list_subscribed_blogs).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Failure.new(:not_ok))
    end

    it 'returns a failure' do
      result = with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id, path) }

      expect(result).to_not be_success
      expect(result.failure).to eq(:not_ok)
    end
  end
end
