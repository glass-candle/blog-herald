RSpec.describe Application::Operations::Chat::Unsubscribe, type: :unit_test do
  subject do
    described_class.new(
      unsubscription_contract: unsubscription_contract,
      chat_repo: chat_repo,
      blog_repo: blog_repo
    )
  end

  let(:unsubscription_contract) { instance_double('Application::Contracts::UnsubscriptionContract') }
  let(:chat_repo) { instance_double('Application::Ports::Repositories::ChatRepo') }
  let(:blog_repo) { instance_double('Application::Ports::Repositories::BlogRepo') }

  let(:chat_uid) { 123_456 }
  let(:blog_codename) { 'codename' }
  let(:chat) { Domain::Entities::Chat.new(chat_uid: chat_uid) }
  let(:blog) { Domain::Entities::Blog.new(codename: blog_codename, title: 'blog_a', link: 'link_a') }

  describe 'without specified blog' do
    before do
      allow(blog_repo).to receive(:by_codename).with(blog_codename).and_return(nil)
    end

    it 'returns a Failure' do
      expect(subject.call(chat_uid, blog_codename)).to_not be_success
    end
  end

  describe 'without specified chat' do
    before do
      allow(blog_repo).to receive(:by_codename).with(blog_codename).and_return(blog)
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(nil)
    end

    it 'returns a Failure' do
      expect(subject.call(chat_uid, blog_codename)).to_not be_success
    end
  end

  describe 'without present subscription' do
    before do
      allow(blog_repo).to receive(:by_codename).with(blog_codename).and_return(blog)
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(chat)
      allow(unsubscription_contract).to receive(:call).with(chat_uid, blog_codename).and_return(Dry::Monads::Result::Failure.new({}))
    end

    it 'returns a Failure' do
      expect(subject.call(chat_uid, blog_codename)).to_not be_success
    end
  end

  describe 'with subscription already present' do
    before do
      allow(blog_repo).to receive(:by_codename).with(blog_codename).and_return(blog)
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(chat)
      allow(unsubscription_contract).to receive(:call).with(chat_uid, blog_codename).and_return(Dry::Monads::Result::Success.new({}))
      allow(chat_repo).to receive(:unsubscribe_from_blog).with(chat, blog).and_return(chat)
    end

    it 'deletes the subscription record' do
      subject.call(chat_uid, blog_codename)

      expect(chat_repo).to have_received(:unsubscribe_from_blog)
    end

    it 'returns a wrapped blog' do
      result = subject.call(chat_uid, blog_codename)

      expect(result).to be_success
      expect(result.value!).to eq(blog)
    end
  end
end
