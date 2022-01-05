RSpec.describe Application::Operations::Chat::ListSubscribedBlogs, type: :unit_test do
  subject { described_class.new(blog_repo: blog_repo) }

  let(:blog_repo) { instance_double('Application::Ports::Repositories::BlogRepo') }

  let!(:blog_struct) { Struct.new(:codename, :title, :link, :subscribed) }

  let(:chat_uid) { '123456' }
  let(:subscribed_blog) { blog_struct.new('blog_c', 'blog_c', 'link_c', true) }
  let(:blogs) do
    [
      blog_struct.new('blog_a', 'blog_a', 'link_a', false),
      blog_struct.new('blog_b', 'blog_b', 'link_b', false),
      subscribed_blog
    ]
  end

  before do
    allow(blog_repo).to receive(:all_with_subscription_status).with(chat_uid).and_return(blogs)
  end

  it 'returns only the relevant blogs' do
    result = subject.call(chat_uid)

    expect(result).to be_success
    expect(result.value!).to eq([subscribed_blog])
  end
end
