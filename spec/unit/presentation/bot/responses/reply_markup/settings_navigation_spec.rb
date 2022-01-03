RSpec.describe Presentation::Bot::Responses::ReplyMarkup::SettingsNavigation, type: :unit_test do
  subject { described_class.new }

  describe '#render' do
    context 'when opted in' do
      let(:is_opted_in) { true }

      it 'returns a keyboard object' do
        keyboard = subject.render(is_opted_in: is_opted_in)

        expect(keyboard.button_rows).to contain_exactly(
          Presentation::Bot::Responses::Button.new(text: '⏹ Unsubscribe', callback_data: 'unsubscribe'),
          Presentation::Bot::Responses::Button.new(text: '🔠 Available blogs', callback_data: 'available_blogs:0')
        )
      end
    end

    context 'when opted out' do
      let(:is_opted_in) { false }

      it 'returns a keyboard object with a valid first row' do
        keyboard = subject.render(is_opted_in: is_opted_in)

        expect(keyboard.button_rows).to contain_exactly(
          Presentation::Bot::Responses::Button.new(text: '▶️ Subscribe', callback_data: 'subscribe'),
          Presentation::Bot::Responses::Button.new(text: '🔠 Available blogs', callback_data: 'available_blogs:0')
        )
      end
    end
  end
end
