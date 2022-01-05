RSpec.describe Application::Operations::Notifications::SendNotification, type: :unit_test do
  subject { described_class.new(chat_notification_repo: chat_notification_repo, chat_repo: chat_repo, post_repo: post_repo, bot: bot) }

  let(:chat_notification_repo) { instance_double('Application::Ports::Repositories::ChatNotificationRepo') }
  let(:chat_repo) { instance_double('Application::Ports::Repositories::ChatRepo') }
  let(:post_repo) { instance_double('Application::Ports::Repositories::PostRepo') }
  let(:bot) { instance_double('Presentation::Bot') }

  let!(:chat_struct) { Struct.new(:id, :chat_uid) }
  let!(:post_struct) { Struct.new(:id, :title, :link, :blog) }
  let!(:chat_notification_struct) { Struct.new(:chat_id, :post_id) }

  let(:chat_id) { 123 }
  let(:chat_uid) { '123456' }
  let(:post_ids) { [3, 4, 5] }
  let(:actualized_post_ids) { [3, 6] }
  let(:chat) { chat_struct.new(1, chat_uid) }
  let(:blog) { Domain::Entities::Blog.new(codename: 'blog_a', title: 'Blog A', link: 'link_to_blog_a') }
  let(:posts) do
    [
      post_struct.new(4, 'Post A', 'link_to_post_a', blog),
      post_struct.new(5, 'Post B', 'link_to_post_b', blog)
    ]
  end
  let(:chat_notifications) do
    [
      chat_notification_struct.new(chat.id, 4),
      chat_notification_struct.new(chat.id, 5)
    ]
  end

  before do
    allow(chat_notification_repo).to receive(:all_post_ids_by_chat_id).with(chat_id).and_return(actualized_post_ids)
    allow(post_repo).to receive(:all_by_ids_with_blogs).with([4, 5]).and_return(posts)
    allow(chat_repo).to receive(:find).with(123).and_return(chat)
    allow(chat_notification_repo).to receive(:persist_notifications).with(chat_id, [4, 5]) do |&block|
      result = block.call
      result.success? ? chat_notifications : nil
    end
  end

  describe 'when the message is sent' do
    before do
      allow(bot).to receive(:notify).with(chat_uid, posts).and_return(Dry::Monads::Result::Success.new(:sent))
    end

    it 'returns wrapped chat_notifications' do
      result = subject.call(chat_id, post_ids)

      expect(result).to be_success
      expect(result.value!).to eq(chat_notifications)
    end
  end

  describe 'when the message is not sent' do
    before do
      allow(bot).to receive(:notify).with(chat_uid, posts).and_return(Dry::Monads::Result::Failure.new(:not_sent))
    end

    it 'returns nil wrapped in Success' do
      result = subject.call(chat_id, post_ids)

      expect(result).to be_success
      expect(result.value!).to eq(nil)
    end
  end
end
