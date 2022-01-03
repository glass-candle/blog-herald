RSpec.describe Application::Operations::Chat::ListBlogStatuses, type: :unit_test do
  subject { described_class.new(blog_repo: blog_repo) }

  let(:blog_repo) { instance_double('Application::Ports::Repositories::BlogRepo') }

  let(:chat_uid) { 123_456 }
  let(:blogs) do
    [
      Domain::Entities::Blog.new(codename: 'blog_a', title: 'blog_a', link: 'link_a'),
      Domain::Entities::Blog.new(codename: 'blog_b', title: 'blog_b', link: 'link_b')
    ]
  end

  before do
    allow(blog_repo).to receive(:all_with_subscription_status).with(chat_uid).and_return(blogs)
  end

  it 'returns the blogs' do
    result = subject.call(chat_uid)

    expect(result).to be_success
    expect(result.value!).to eq(blogs)
  end
end
