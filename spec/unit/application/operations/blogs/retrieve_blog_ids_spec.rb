RSpec.describe Application::Operations::Blogs::RetrieveBlogIds, type: :unit_test do
  subject { described_class.new(blog_repo: blog_repo) }

  let(:blog_repo) { instance_double('Application::Ports::Repositories::BlogRepo') }

  let!(:blog_struct) { Struct.new(:id) }
  let(:blogs) do
    [blog_struct.new(1), blog_struct.new(1), blog_struct.new(1)]
  end

  before do
    allow(blog_repo).to receive(:all).with(no_args).and_return(blogs)
  end

  it 'returns the blog ids' do
    result = subject.call

    expect(result).to be_success
    expect(result.value!).to eq(blogs.map(&:id))
  end
end
