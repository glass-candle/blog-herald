RSpec.describe Application::Operations::Chat::OptInStatus, type: :unit_test do
  subject { described_class.new(chat_repo: chat_repo) }

  let(:chat_repo) { instance_double('Application::Ports::Repositories::ChatRepo') }

  let(:chat_uid) { '123456' }
  let(:chat) { Domain::Entities::Chat.new(chat_uid: chat_uid) }

  describe 'with chat present' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(chat)
    end

    it "returns a wrapped 'true'" do
      result = subject.call(chat_uid)

      expect(result).to be_success
      expect(result.value!).to eq(true)
    end
  end

  describe 'with chat not present' do
    before do
      allow(chat_repo).to receive(:by_chat_uid).with(chat_uid).and_return(nil)
    end

    it "returns a wrapped 'false'" do
      result = subject.call(chat_uid)

      expect(result).to be_success
      expect(result.value!).to eq(false)
    end
  end
end
