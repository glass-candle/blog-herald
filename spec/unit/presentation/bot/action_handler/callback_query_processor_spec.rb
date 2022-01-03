RSpec.describe Presentation::Bot::ActionHandler::CallbackQueryProcessor, type: :unit_test do
  subject do
    described_class.new(
      settings: settings,
      opt_in: opt_in,
      opt_out: opt_out,
      available_blogs: available_blogs,
      enabled_blogs: enabled_blogs,
      subscribe: subscribe,
      unsubscribe: unsubscribe
    )
  end

  let(:settings) { instance_double('Presentation::Bot::Actions::CallbackQuery::Settings') }
  let(:opt_in) { instance_double('Presentation::Bot::Actions::CallbackQuery::OptIn') }
  let(:opt_out) { instance_double('Presentation::Bot::Actions::CallbackQuery::OptOut') }
  let(:available_blogs) { instance_double('Presentation::Bot::Actions::CallbackQuery::AvailableBlogs') }
  let(:enabled_blogs) { instance_double('Presentation::Bot::Actions::CallbackQuery::EnabledBlogs') }
  let(:subscribe) { instance_double('Presentation::Bot::Actions::CallbackQuery::Subscribe') }
  let(:unsubscribe) { instance_double('Presentation::Bot::Actions::CallbackQuery::Unsubscribe') }

  let(:chat_id) { '123456' }
  let(:message_id) { '123' }

  describe '#call' do
    before do
      allow(action).to receive(:call).with(chat_id, message_id, any_args).and_return(Dry::Monads::Result::Success.new(:ok))
    end

    context "'settings' action" do
      let(:action) { settings }
      let(:data) { 'settings' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(action).to have_received(:call)
      end
    end

    context "'opt_in' action" do
      let(:action) { opt_in }
      let(:data) { 'opt_in' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(action).to have_received(:call)
      end
    end

    context "'opt_out' action" do
      let(:action) { opt_out }
      let(:data) { 'opt_out' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(action).to have_received(:call)
      end
    end

    context "'available_blogs' action" do
      let(:action) { available_blogs }
      let(:data) { 'available_blogs:0' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(action).to have_received(:call)
      end
    end

    context "'enabled_blogs' action" do
      let(:action) { enabled_blogs }
      let(:data) { 'enabled_blogs:0' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(action).to have_received(:call)
      end
    end

    context "'subscribe' action" do
      let(:action) { subscribe }
      let(:data) { 'subscribe:codename|enabled_blogs:0' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(action).to have_received(:call)
      end
    end

    context "'unsubscribe' action" do
      let(:action) { unsubscribe }
      let(:data) { 'unsubscribe:codename|enabled_blogs:0' }

      it 'calls the right action' do
        subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(action).to have_received(:call)
      end
    end

    context 'with an unknown action' do
      let(:action) { double }
      let(:data) { 'unknown' }

      it 'returns a success' do
        result = subject.call(chat_id: chat_id, message_id: message_id, data: data)

        expect(result).to be_success
        expect(result.value!).to eq(:unmatched)
      end
    end
  end
end
