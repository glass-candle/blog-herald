RSpec.describe Application::Operations::Chat::OptOut, type: :unit_test do
  subject { described_class.new(chat_repo: chat_repo) }

  let(:chat_repo) { instance_double('Application::Ports::Repositories::ChatRepo') }

  let(:chat_uid) { 123_456 }
  let(:chat) { Domain::Entities::Chat.new(chat_uid: chat_uid) }

  describe 'with chat deleted mid-operation' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(chat)
      allow(chat_repo).to receive(:delete_by_chat_uid).with(chat_uid).and_raise(StandardError)
    end

    it 'propagates an exception' do
      expect { subject.call(chat_uid) }.to raise_error(StandardError)
    end
  end

  describe 'with chat not present' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(nil)
      allow(chat_repo).to receive(:delete_by_chat_uid).with(chat_uid).and_return(0)
    end

    it 'does not attempt to delete a record' do
      subject.call(chat_uid)

      expect(chat_repo).to_not have_received(:delete_by_chat_uid)
    end

    it 'returns Success' do
      expect(subject.call(chat_uid)).to be_success
    end
  end

  describe 'with chat present' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(chat)
      allow(chat_repo).to receive(:delete_by_chat_uid).with(chat_uid).and_return(1)
    end

    it 'deletes a chat record' do
      subject.call(chat_uid)

      expect(chat_repo).to have_received(:delete_by_chat_uid)
    end

    it 'returns Success' do
      expect(subject.call(chat_uid)).to be_success
    end
  end
end
