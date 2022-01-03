RSpec.describe Presentation::Bot::Actions::CallbackQuery::Unsubscribe, type: :unit_test do
  subject do
    described_class.new(unsubscribe: unsubscribe)
  end

  include Dry::Effects::Handler::Reader(:action_processor)

  let(:unsubscribe) { instance_double('Application::Operations::Chat::Unsubscribe') }

  let(:action_processor) { instance_double('Presentation::Bot::ActionHandler::CallbackQueryProcessor') }

  let(:chat_id) { '123456' }
  let(:message_id) { '123' }
  let(:path) { "unsubscribe:#{codename}|#{callback_path}" }
  let(:codename) { 'codename' }
  let(:callback_path) { 'available_blogs:1' }

  describe 'with all operations successful' do
    before do
      allow(action_processor).to receive(:call).with(
        chat_id: chat_id,
        message_id: message_id,
        data: callback_path
      ).and_return(Dry::Monads::Result::Success.new(:ok))

      allow(unsubscribe).to receive(:call).with(chat_id, codename).and_return(Dry::Monads::Result::Success.new(double))
    end

    it 'calls action processor back' do
      with_action_processor(action_processor) { subject.call(chat_id, message_id, path) }

      expect(action_processor).to have_received(:call)
    end

    it 'returns a success' do
      result = with_action_processor(action_processor) { subject.call(chat_id, message_id, path) }

      expect(result).to be_success
      expect(result.value!).to eq(:ok)
    end
  end

  describe 'with a failed operation' do
    before do
      allow(unsubscribe).to receive(:call).with(chat_id, codename).and_return(Dry::Monads::Result::Failure.new(:not_ok))
    end

    it 'returns a failure' do
      result = with_action_processor(action_processor) { subject.call(chat_id, message_id, path) }

      expect(result).to_not be_success
      expect(result.failure).to eq(:not_ok)
    end
  end

  describe 'with an invalid path' do
    let(:path) { "unsubscribe:#{codename}|gibberish" }

    it 'raises an ArgumentError' do
      expect { with_action_processor(action_processor) { subject.call(chat_id, message_id, path) } }.to raise_error(ArgumentError)
    end
  end
end
