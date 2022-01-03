RSpec.describe Presentation::Bot::Actions::CallbackQuery::OptOut, type: :unit_test do
  subject do
    described_class.new(
      opt_out: opt_out,
      settings_prompt: settings_prompt,
      settings_navigation: settings_navigation
    )
  end

  include Dry::Effects::Handler::Reader(:bot_adapter)

  let(:opt_out) { instance_double('Application::Operations::Chat::OptOut') }
  let(:settings_prompt) { instance_double('Presentation::Bot::Responses::Text::SettingsPrompt') }
  let(:settings_navigation) { instance_double('Presentation::Bot::Responses::ReplyMarkup::SettingsNavigation') }

  let(:bot_adapter) { instance_double('BotAdapter') }

  let(:chat_id) { '123456' }
  let(:message_id) { '123' }

  describe 'with all operations successful' do
    let(:text) { double }
    let(:reply_markup) { double }

    before do
      allow(bot_adapter).to receive(:send_message).with(
        chat_id: chat_id,
        text: "You have successfully unsubscribed and won't be receiving any updates."
      ).and_return(Dry::Monads::Result::Success.new(:ok))

      allow(bot_adapter).to receive(:edit_message_text).with(
        chat_id: chat_id,
        message_id: message_id,
        text: text,
        reply_markup: reply_markup
      ).and_return(Dry::Monads::Result::Success.new(:ok))

      allow(opt_out).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Success.new(chat_id))
      allow(settings_prompt).to receive(:render).with(is_opted_in: false).and_return(text)
      allow(settings_navigation).to receive(:render).with(is_opted_in: false).and_return(reply_markup)
    end

    it 'sends a message' do
      with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id) }

      expect(bot_adapter).to have_received(:send_message)
    end

    it 'edits the message data' do
      with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id) }

      expect(bot_adapter).to have_received(:edit_message_text)
    end

    it 'returns a success' do
      result = with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id) }

      expect(result).to be_success
      expect(result.value!).to eq(:ok)
    end
  end

  describe 'with a failed operation' do
    before do
      allow(opt_out).to receive(:call).with(chat_id).and_return(Dry::Monads::Result::Failure.new(:not_ok))
    end

    it 'returns a failure' do
      result = with_bot_adapter(bot_adapter) { subject.call(chat_id, message_id) }

      expect(result).to_not be_success
      expect(result.failure).to eq(:not_ok)
    end
  end
end
