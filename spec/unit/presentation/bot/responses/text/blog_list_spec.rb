RSpec.describe Presentation::Bot::Responses::Text::BlogList, type: :unit_test do
  subject { described_class.new }

  describe '#render' do
    context 'without blogs' do
      let(:blogs) { [] }

      it 'returns a correct text' do
        text = subject.render(blogs: blogs)

        expect(text).to eq('No blogs available')
      end
    end

    context 'with blogs' do
      let(:blogs) do
        [
          Domain::Entities::Blog.new(codename: 'blog_a', title: 'blog_a', link: 'link_a'),
          Domain::Entities::Blog.new(codename: 'blog_b', title: 'blog_b', link: 'link_b'),
          Domain::Entities::Blog.new(codename: 'blog_c', title: 'blog_c', link: 'link_c')
        ]
      end

      it 'returns a correct text' do
        text = subject.render(blogs: blogs)

        expect(text).to eq(<<~TEXT)
          The following blogs are available:

          blog_a - link_a
          blog_b - link_b
          blog_c - link_c
        TEXT
      end
    end
  end
end
