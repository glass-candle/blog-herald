RSpec.describe Presentation::Bot::Notifier, type: :unit_test do
  subject { described_class.new }

  include Dry::Effects::Handler::Reader(:bot_adapter)

  let(:chat_id) { '123456' }
  let!(:blog_struct) { Struct.new(:title) }
  let!(:post_struct) { Struct.new(:title, :link, :blog) }

  let(:bot_adapter) { instance_double('BotAdapter') }

  describe 'when a message is sent' do
    before do
      allow(bot_adapter)
        .to receive(:send_message)
        .with(chat_id: chat_id, text: instance_of(String))
        .and_return(Dry::Monads::Result::Success.new(:ok))
    end

    describe 'with posts from a single blog' do
      let(:blog) { blog_struct.new('Blog A') }
      let(:posts) do
        [
          post_struct.new('Post A', 'link_to_post_a', blog),
          post_struct.new('Post B', 'link_to_post_b', blog),
          post_struct.new('Post C', 'link_to_post_c', blog)
        ]
      end
      let(:expected_text) do
        <<~TEXT
          Blog A has new posts:

          Post A - link_to_post_a
          Post B - link_to_post_b
          Post C - link_to_post_c
        TEXT
      end

      it 'generates a correct text' do
        with_bot_adapter(bot_adapter) { subject.call(chat_id, posts) }

        expect(bot_adapter).to have_received(:send_message).with(chat_id: chat_id, text: expected_text)
      end

      it 'returns success' do
        result = with_bot_adapter(bot_adapter) { subject.call(chat_id, posts) }
        expect(result).to be_success
      end
    end

    describe 'with posts from multiple blogs' do
      let(:blog_a) { blog_struct.new('Blog A') }
      let(:blog_b) { blog_struct.new('Blog B') }
      let(:posts) do
        [
          post_struct.new('Post A', 'link_to_post_a', blog_a),
          post_struct.new('Post B', 'link_to_post_b', blog_b),
          post_struct.new('Post C', 'link_to_post_c', blog_b)
        ]
      end
      let(:expected_text) do
        <<~TEXT
          The following blogs have new posts:

          Blog A:
          Post A - link_to_post_a

          Blog B:
          Post B - link_to_post_b
          Post C - link_to_post_c

        TEXT
      end

      it 'generates a correct text' do
        with_bot_adapter(bot_adapter) { subject.call(chat_id, posts) }

        expect(bot_adapter).to have_received(:send_message).with(chat_id: chat_id, text: expected_text)
      end

      it 'returns a success' do
        result = with_bot_adapter(bot_adapter) { subject.call(chat_id, posts) }
        expect(result).to be_success
      end
    end
  end

  describe 'when a message is not sent' do
    let(:blog) { blog_struct.new('Blog B') }
    let(:posts) { [post_struct.new('Post A', 'link_to_post_a', blog)] }

    before do
      allow(bot_adapter)
        .to receive(:send_message)
        .with(chat_id: chat_id, text: instance_of(String))
        .and_return(Dry::Monads::Result::Failure.new(msg: :telegram_bot_exception))
    end

    it 'returns a failure' do
      result = with_bot_adapter(bot_adapter) { subject.call(chat_id, posts) }
      expect(result).to_not be_success
    end
  end
end
