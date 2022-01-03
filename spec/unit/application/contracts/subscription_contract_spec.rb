RSpec.describe Application::Contracts::SubscriptionContract, type: :unit_test do
  subject { described_class.new(chat_repo: chat_repo) }

  let(:chat_repo) { instance_double('Application::Ports::Repositories::ChatRepo') }

  describe 'with invalid params' do
    let(:chat_uid) { 123_456 }
    let(:blog_codename) { 0 }

    it 'returns a failed contract result' do
      result = subject.call(chat_uid: chat_uid, blog_codename: blog_codename)

      expect(result).to_not be_success
      expect(result.errors.to_h).to include(:chat_uid, :blog_codename)
    end
  end

  describe 'with valid params' do
    let(:chat_uid) { '123456' }
    let(:blog_codename) { 'codename' }

    context 'with existing subscription' do
      before do
        allow(chat_repo).to receive(:subscription_exists?).with(chat_uid, blog_codename).and_return(true)
      end

      it 'returns a failed contract result' do
        result = subject.call(chat_uid: chat_uid, blog_codename: blog_codename)

        expect(result).to_not be_success
        expect(result.errors.to_h).to include(:chat_uid)
      end
    end

    context 'without existing subscription' do
      before do
        allow(chat_repo).to receive(:subscription_exists?).with(chat_uid, blog_codename).and_return(false)
      end

      it 'returns a succeeded contract result' do
        result = subject.call(chat_uid: chat_uid, blog_codename: blog_codename)

        expect(result).to be_success
        expect(result.to_h).to eq(chat_uid: chat_uid, blog_codename: blog_codename)
      end
    end
  end
end
