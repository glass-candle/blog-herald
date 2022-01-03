RSpec.describe Presentation::Bot::Responses::Text::SettingsPrompt, type: :unit_test do
  subject { described_class.new }

  describe '#render' do
    context 'when opted in' do
      let(:is_opted_in) { true }

      it 'returns a correct text' do
        text = subject.render(is_opted_in: is_opted_in)

        expect(text).to eq("Hey! If you don't want to receieve any more blogpost updates, press the 'Unsubscribe' button down below.")
      end
    end

    context 'when opted out' do
      let(:is_opted_in) { false }

      it 'returns a correct text' do
        text = subject.render(is_opted_in: is_opted_in)

        expect(text).to eq("Hey! Press the 'Subscribe' button down below to start getting blogpost updates.")
      end
    end
  end
end
