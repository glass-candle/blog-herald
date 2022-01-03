RSpec.describe Presentation::Bot::Responses::ReplyMarkup::BlogListNavigation, type: :unit_test do
  subject { described_class.new }

  describe '#render' do
    it 'returns a keyboard object' do
      keyboard = subject.render

      expect(keyboard.button_rows).to contain_exactly(Presentation::Bot::Responses::Button.new(text: '↩️ Back', callback_data: 'settings'))
    end
  end
end
