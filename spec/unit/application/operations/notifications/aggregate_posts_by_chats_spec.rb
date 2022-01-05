RSpec.describe Application::Operations::Notifications::AggregatePostsByChats, type: :unit_test do
  subject { described_class.new(post_repo: post_repo) }

  let(:post_repo) { instance_double('Application::Ports::Repositories::PostRepo') }

  let!(:tuple_struct) { Struct.new(:chat_id, :post_ids) }
  let(:tuples) do
    [
      tuple_struct.new(1, [1, 2, 3]),
      tuple_struct.new(2, [1]),
      tuple_struct.new(3, [2, 3, 4])
    ]
  end

  before do
    allow(post_repo).to receive(:aggregate_relevant_by_chat_ids).with(no_args).and_return(tuples)
  end

  it 'returns the tuples' do
    result = subject.call

    expect(result).to be_success
    expect(result.value!).to eq(tuples)
  end
end
