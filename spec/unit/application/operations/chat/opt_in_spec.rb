RSpec.describe Application::Operations::Chat::OptIn, type: :unit_test do
  subject { described_class.new(chat_repo: chat_repo, blog_repo: blog_repo) }

  let(:chat_repo) { instance_double('Application::Ports::Repositories::ChatRepo') }
  let(:blog_repo) { instance_double('Application::Ports::Repositories::BlogRepo') }

  let(:chat_uid) { 123_456 }
  let(:chat) { Domain::Entities::Chat.new(chat_uid: chat_uid) }
  let(:blogs) do
    [
      Domain::Entities::Blog.new(codename: 'blog_a', title: 'blog_a', link: 'link_a'),
      Domain::Entities::Blog.new(codename: 'blog_b', title: 'blog_b', link: 'link_b')
    ]
  end

  before do
    allow(blog_repo).to receive(:all).with(no_args).and_return(blogs)
  end

  describe 'with chat inserted mid-operation' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(nil)
      allow(chat_repo).to receive(:create_with_blogs).with(chat_uid, blogs).and_raise(StandardError)
    end

    it 'propagates an exception' do
      expect { subject.call(chat_uid) }.to raise_error(StandardError)
    end
  end

  describe 'with chat not present' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(nil)
      allow(chat_repo).to receive(:create_with_blogs).with(chat_uid, blogs).and_return(chat)
    end

    it 'creates a chat record' do
      subject.call(chat_uid)

      expect(chat_repo).to have_received(:create_with_blogs)
    end

    it 'returns Success' do
      expect(subject.call(chat_uid)).to be_success
    end
  end

  describe 'with chat already present' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(chat)
      allow(chat_repo).to receive(:create_with_blogs).with(chat_uid, blogs).and_return(chat)
    end

    it 'does not attempt to create a chat record' do
      subject.call(chat_uid)

      expect(chat_repo).to_not have_received(:create_with_blogs)
    end

    it 'returns Success' do
      expect(subject.call(chat_uid)).to be_success
    end
  end
end
