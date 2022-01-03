RSpec.describe Presentation::Bot::ActionHandler::MessageProcessor, type: :unit_test do
  subject do
    described_class.new(settings: settings)
  end

  let(:settings) { instance_double('Presentation::Bot::Actions::Message::Settings') }

  let(:chat_id) { '123456' }

  describe '#call' do
    before do
      allow(action).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(:ok))
    end

    context "'settings' action" do
      let(:action) { settings }
      let(:text) { '/settings' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, text: text)

        expect(action).to have_received(:call)
      end
    end

    context 'with an unknown action' do
      let(:action) { double }
      let(:text) { '/unknown' }

      it 'returns a success' do
        result = subject.call(chat_id: chat_id, text: text)

        expect(result).to be_success
        expect(result.value!).to eq(:unmatched)
      end
    end
  end
end
