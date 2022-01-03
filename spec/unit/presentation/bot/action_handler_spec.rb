RSpec.describe Presentation::Bot::ActionHandler, type: :unit_test do
  subject { described_class.new(callback_query_processor: callback_query_processor, message_processor: message_processor) }

  include Dry::Effects::Handler::Reader(:bot_adapter)

  let(:callback_query_processor) { instance_double('Presentation::Bot::ActionHandler::CallbackQueryProcessor') }
  let(:message_processor) { instance_double('Presentation::Bot::ActionHandler::MessageProcessor') }

  let(:bot_adapter) { instance_double('BotAdapter') }

  shared_examples '#call' do
    context 'with a failed processor result' do
      let(:processor_result) { Dry::Monads::Result::Failure.new(:not_ok) }

      before do
        allow(bot_adapter)
          .to receive(:send_message)
          .with(chat_id: chat_id, text: 'Whoops! Something went wrong, try again.')
          .and_return(Dry::Monads::Result::Success.new(:ok))
      end

      it 'sends a failure messsage to the user' do
        with_bot_adapter(bot_adapter) { subject.call(payload_object) }

        expect(bot_adapter).to have_received(:send_message)
      end

      it 'propagates and returns the processor failure result' do
        result = with_bot_adapter(bot_adapter) { subject.call(payload_object) }

        expect(result).to_not be_success
        expect(result).to eq(processor_result)
      end
    end

    context 'with a successful processor result' do
      let(:processor_result) { Dry::Monads::Result::Success.new(:ok) }

      it 'returns the processor success result' do
        result = with_bot_adapter(bot_adapter) { subject.call(payload_object) }

        expect(result).to be_success
        expect(result).to eq(processor_result)
      end
    end
  end

  describe 'with CallbackQuery payload object' do
    let(:chat_id) { '123456' }
    let(:message_id) { '123' }
    let(:data) { 'data' }
    let(:payload_object) { Presentation::Bot::CallbackQuery.new(chat_id: chat_id, message_id: message_id, data: data) }

    before do
      allow(callback_query_processor).to receive(:call).with(chat_id: chat_id, message_id: message_id, data: data).and_return(processor_result)
    end

    it_behaves_like '#call'
  end

  describe 'with Message payload object' do
    let(:chat_id) { '123456' }
    let(:text) { 'text' }
    let(:payload_object) { Presentation::Bot::Message.new(chat_id: chat_id, text: text) }

    before do
      allow(message_processor).to receive(:call).with(chat_id: chat_id, text: text).and_return(processor_result)
    end

    it_behaves_like '#call'
  end

  describe 'with an unknown payload object' do
    let(:payload_object) { Struct.new(:something).new(:a) }

    it 'returns a success' do
      result = with_bot_adapter(bot_adapter) { subject.call(payload_object) }

      expect(result).to be_success
      expect(result.value!).to eq(:unknown_payload_type)
    end
  end
end
