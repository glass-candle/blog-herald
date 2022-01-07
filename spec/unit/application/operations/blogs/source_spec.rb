RSpec.describe Application::Operations::Blogs::Source, type: :unit_test do
  subject do
    described_class.new(
      blog_repo: blog_repo,
      post_repo: post_repo,
      crawler: crawler
    )
  end

  let(:blog_repo) { instance_double('Application::Ports::Repositories::BlogRepo') }
  let(:post_repo) { instance_double('Application::Ports::Repositories::PostRepo') }
  let(:crawler) { instance_double('Infra::Crawler') }

  let!(:blog_struct) { Struct.new(:id, :posts) }
  let!(:post_struct) { Struct.new(:link) }

  let(:blog) { blog_struct.new(1, posts) }
  let(:posts) { [post_struct.new(:link_a)] }
  let(:post_dtos) { [post_struct.new(:link_a), post_struct.new(:link_b), post_struct.new(:link_c)] }
  let(:created_posts) { [post_struct.new(:link_b), post_struct.new(:link_c)] }

  before do
    allow(blog_repo).to receive(:with_posts).with(1).and_return(blog)
    allow(crawler).to receive(:call).with(blog).and_return(Dry::Monads::Result::Success.new(post_dtos))
    allow(post_repo).to receive(:create_posts).with(post_dtos[1..], 1).and_return(created_posts, 1)
  end

  it 'returns the posts' do
    result = subject.call(1)

    expect(result).to be_success
    expect(result.value!).to eq(created_posts)
  end
end
