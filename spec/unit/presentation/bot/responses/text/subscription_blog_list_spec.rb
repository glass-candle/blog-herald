RSpec.describe Presentation::Bot::Responses::Text::SubscriptionBlogList, type: :unit_test do
  subject { described_class.new }

  let!(:blog_struct) { Struct.new(:codename, :title, :link, :subscribed) }

  let(:subscribed_blogs) do
    [
      { item: blog_struct.new('blog_a', 'blog_a', 'link_a', true), in_page: true },
      { item: blog_struct.new('blog_b', 'blog_b', 'link_b', true), in_page: true },
      { item: blog_struct.new('blog_c', 'blog_c', 'link_c', true), in_page: true }
    ]
  end

  let(:unsubscribed_blogs) do
    [
      { item: blog_struct.new('blog_d', 'blog_d', 'link_d', false), in_page: true },
      { item: blog_struct.new('blog_e', 'blog_e', 'link_e', false), in_page: false },
      { item: blog_struct.new('blog_f', 'blog_f', 'link_f', false), in_page: false }
    ]
  end

  describe '#render' do
    context 'with only subscribed blogs' do
      let(:only_subscribed) { true }

      context 'with blogs present' do
        let(:paged_blogs) { [*subscribed_blogs] }

        it 'returns a correct text' do
          text = subject.render(paged_blogs: paged_blogs, only_subscribed: only_subscribed)

          expect(text).to eq(<<~TEXT)
            You are subscribed to the following blogs:

            ✅  > blog_a - link_a
            ✅  > blog_b - link_b
            ✅  > blog_c - link_c
          TEXT
        end
      end

      context 'without any blogs present' do
        let(:paged_blogs) { [] }

        it 'returns a correct text' do
          text = subject.render(paged_blogs: paged_blogs, only_subscribed: only_subscribed)

          expect(text).to eq('You are not subscribed to any blogs.')
        end
      end
    end

    context 'with all blogs' do
      let(:only_subscribed) { false }

      context 'with blogs present' do
        let(:paged_blogs) { [*subscribed_blogs, *unsubscribed_blogs] }

        it 'returns a correct text' do
          text = subject.render(paged_blogs: paged_blogs, only_subscribed: only_subscribed)

          expect(text).to eq(<<~TEXT)
            The following blogs are available:

            ✅  > blog_a - link_a
            ✅  > blog_b - link_b
            ✅  > blog_c - link_c
            ❌  > blog_d - link_d
            ❌ blog_e - link_e
            ❌ blog_f - link_f
          TEXT
        end
      end

      context 'without any blogs present' do
        let(:paged_blogs) { [] }

        it 'returns a correct text' do
          text = subject.render(paged_blogs: paged_blogs, only_subscribed: only_subscribed)

          expect(text).to eq('No blogs available.')
        end
      end
    end
  end
end
