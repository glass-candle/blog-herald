# frozen_string_literal: true

ROM::SQL.migration do # rubocop:disable Metrics/BlockLength
  up do # rubocop:disable Metrics/BlockLength
    App.start(:zeitwerk)

    blog_struct = Struct.new(:codename, :title, :link)
    blogs = [
      blog_struct.new(:ilyabylich.to_s, "Ilya Bylich\'s blog", 'https://ilyabylich.svbtle.com/'),
      blog_struct.new(:kirshatrov.to_s, "Kir Shatrov\'s blog", 'https://kirshatrov.com/posts/'),
      blog_struct.new(:peterzhu.to_s, "Peter Zhu\'s blog", 'https://blog.peterzhu.ca/'),
      blog_struct.new(:mikeperham.to_s, "Mike Perham\'s blog", 'https://www.mikeperham.com/'),
      blog_struct.new(:tinyprojects.to_s, "'Tiny Projects' blog", 'https://tinyprojects.dev/'),
      blog_struct.new(:rtcsec.to_s, 'Real-time communications security blog', 'https://www.rtcsec.com/'),
      blog_struct.new(:saeloun.to_s, 'Saeloun blog', 'https://www.saeloun.com/'),
      blog_struct.new(:secretclub.to_s, 'secret.club', 'https://secret.club/'),
      blog_struct.new(:netflix.to_s, 'Netflix Tech Blog', 'https://netflixtechblog.com/'),
      blog_struct.new(:fasterthanlime.to_s, "Amos' blog", 'https://fasterthanli.me/'),
      blog_struct.new(:appsignal.to_s, 'AppSignal blog', 'https://blog.appsignal.com/'),
      blog_struct.new(:evilmartians.to_s, 'EvilMartians blog', 'https://evilmartians.com/chronicles'),
      blog_struct.new(:joshhaberman.to_s, "Josh Haberman's blog", 'https://blog.reverberate.org/'),
      blog_struct.new(:mbuffett.to_s, 'mbuffett blog', 'https://mbuffett.com/'),
      blog_struct.new(:eregon.to_s, 'On the Edge of Ruby blog', 'https://eregon.me/blog/'),
      blog_struct.new(:speedshop.to_s, 'Speedshop blog', 'https://www.speedshop.co/blog/'),
      blog_struct.new(:bigbinary.to_s, 'BigBinary blog', 'https://www.bigbinary.com/blog'),
      blog_struct.new(:arkency.to_s, 'Arkency blog', 'https://blog.arkency.com/'),
      blog_struct.new(:howthingswork.to_s, "Bartosz Ciechanowski's 'How Things Work' blog", 'https://ciechanow.ski/archives/'),
      blog_struct.new(:chrisseaton.to_s, "Chris Seaton's TruffleRuby blog", 'https://chrisseaton.com/truffleruby/'),
      blog_struct.new(:uber.to_s, 'Uber Engineering blog', 'https://eng.uber.com/'),
      blog_struct.new(:tejasbubane.to_s, "Tejas Bubane's blog", 'https://tejasbubane.github.io/'),
      blog_struct.new(:josefstrzibny.to_s, "Josef Strzibny's blog", 'https://nts.strzibny.name/'),
      blog_struct.new(:burke.to_s, "burke's blog", 'https://notes.burke.libbey.me/'),
      blog_struct.new(:wjwh.to_s, "Wander Hillen's blog", 'http://www.wjwh.eu/'),
      blog_struct.new(:timriley.to_s, "Tim Riley's blog", 'https://timriley.info/writing/'),
      blog_struct.new(:rubyyagi.to_s, 'Ruby Yagi blog', 'https://rubyyagi.com/archive/'),
      blog_struct.new(:joyfulbikeshedding.to_s, 'Joyful Bikeshedding blog', 'https://www.joyfulbikeshedding.com/'),
      blog_struct.new(:thoughtbot.to_s, 'Thoughtbot blog', 'https://thoughtbot.com/blog/web'),
      blog_struct.new(:aaronpatterson.to_s, "Aaron Patterson's blog", 'https://tenderlovemaking.com/'),
      blog_struct.new(:noteflakes.to_s, 'Noteflakes blog', 'https://noteflakes.com/archive'),
      blog_struct.new(:idiosyncraticruby.to_s, 'Idiosyncratic Ruby blog', 'https://idiosyncratic-ruby.com/'),
      blog_struct.new(:meta.to_s, 'Meta Engineering blog', 'https://engineering.fb.com/'),
      blog_struct.new(:ivanvelichko.to_s, "Ivan Velichko's blog", 'https://iximiuz.com/en/archive/'),
      blog_struct.new(:samwilliams.to_s, "Sam William's blog", 'https://www.codeotaku.com/journal/index'),
      blog_struct.new(:remimercier.to_s, "Remi Mercier's blog", 'https://remimercier.com/blog/'),
      blog_struct.new(:brandur.to_s, "Brandur's blog", 'https://brandur.org/articles')
    ]

    App['application.ports.repositories.blog_repo'].upsert(blogs)
  end

  down do # rubocop:disable Metrics/BlockLength
    App.start(:zeitwerk)

    codenames = %i[
      ilyabylich
      kirshatrov
      peterzhu
      mikeperham
      tinyprojects
      rtcsec
      saeloun
      secretclub
      netflix
      fasterthanlime
      appsignal
      evilmartians
      joshhaberman
      mbuffett
      eregon
      speedshop
      bigbinary
      arkency
      howthingswork
      chrisseaton
      uber
      tejasbubane
      josefstrzibny
      burke
      wjwh
      timriley
      rubyyagi
      joyfulbikeshedding
      thoughtbot
      aaronpatterson
      noteflakes
      idiosyncraticruby
      meta
      ivanvelichko
      samwilliams
      remimercier
      brandur
    ].map(&:to_s)

    App['application.ports.repositories.blog_repo'].delete_by_codenames(codenames)
  end
end
