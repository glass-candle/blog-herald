RSpec.describe Presentation::Bot::Responses::ReplyMarkup::PagedBlogListNavigation, type: :unit_test do
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
      { item: blog_struct.new('blog_e', 'blog_e', 'link_e', false), in_page: true },
      { item: blog_struct.new('blog_f', 'blog_f', 'link_f', false), in_page: false }
    ]
  end

  let(:paged_blogs) { [*subscribed_blogs, *unsubscribed_blogs] }
  let(:path) { 'available_blogs:0' }
  let(:current_page) { 0 }
  let(:total_pages) { 1 }

  describe '#render' do
    context "with 'available_blogs' path" do
      let(:path) { 'available_blogs:1' }

      it 'returns a keyboard object with a valid first row' do
        keyboard = subject.render(path: path, paged_blogs: paged_blogs, current_page: current_page, total_pages: total_pages)

        expect(keyboard.button_rows.first).to contain_exactly(
          Presentation::Bot::Responses::Button.new(text: '↩️ Back', callback_data: 'settings'),
          Presentation::Bot::Responses::Button.new(text: '❇️ Enabled blogs', callback_data: 'enabled_blogs:0')
        )
      end
    end

    context "with 'enabled_blogs' path" do
      let(:path) { 'enabled_blogs:1' }

      it 'returns a keyboard object with a valid first row' do
        keyboard = subject.render(path: path, paged_blogs: paged_blogs, current_page: current_page, total_pages: total_pages)

        expect(keyboard.button_rows.first).to contain_exactly(
          Presentation::Bot::Responses::Button.new(text: '↩️ Back', callback_data: 'settings'),
          Presentation::Bot::Responses::Button.new(text: '🔠 Available blogs', callback_data: 'available_blogs:0')
        )
      end
    end

    context 'with a page 1 out of 2' do
      let(:current_page) { 0 }
      let(:total_pages) { 1 }

      it 'returns a keyboard object with a valid last row' do
        keyboard = subject.render(path: path, paged_blogs: paged_blogs, current_page: current_page, total_pages: total_pages)

        expect(keyboard.button_rows.last).to contain_exactly(
          Presentation::Bot::Responses::Button.new(text: '⏩ Next', callback_data: 'available_blogs:1')
        )
      end
    end

    context 'with a page 2 out of 2' do
      let(:current_page) { 1 }
      let(:total_pages) { 1 }

      it 'returns a keyboard object with a valid last row' do
        keyboard = subject.render(path: path, paged_blogs: paged_blogs, current_page: current_page, total_pages: total_pages)

        expect(keyboard.button_rows.last).to contain_exactly(
          Presentation::Bot::Responses::Button.new(text: '⏪ Previous', callback_data: 'available_blogs:0')
        )
      end
    end

    it 'returns a keyboard object with valid subscription rows' do
      keyboard = subject.render(path: path, paged_blogs: paged_blogs, current_page: current_page, total_pages: total_pages)

      expect(keyboard.button_rows[1..-2]).to contain_exactly(
        *subscribed_blogs.map do |paged_blog|
          blog = paged_blog[:item]
          Presentation::Bot::Responses::Button.new(text: "❌ Unsubscribe from #{blog.title}", callback_data: "unsubscribe:#{blog.codename}|#{path}")
        end,
        *unsubscribed_blogs.first(2).map do |paged_blog|
          blog = paged_blog[:item]
          Presentation::Bot::Responses::Button.new(text: "✅ Subscribe to #{blog.title}", callback_data: "subscribe:#{blog.codename}|#{path}")
        end
      )
    end
  end
end
