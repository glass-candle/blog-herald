# frozen_string_literal: true

module Infra
  class Crawler
    class HandlerResolver
      include Dry::Monads::Maybe::Mixin
      include Dry::Monads::Result::Mixin

      HANDLERS = {
        ilyabylich: Crawler::Handlers::Ilyabylich,
        kirshatrov: Crawler::Handlers::Kirshatrov,
        peterzhu: Crawler::Handlers::Peterzhu,
        mikeperham: Crawler::Handlers::Mikeperham,
        tinyprojects: Crawler::Handlers::Tinyprojects,
        rtcsec: Crawler::Handlers::Rtcsec,
        saeloun: Crawler::Handlers::Saeloun,
        secretclub: Crawler::Handlers::Secretclub,
        netflix: Crawler::Handlers::Netflix,
        fasterthanlime: Crawler::Handlers::Fasterthanlime,
        evilmartians: Crawler::Handlers::Evilmartians,
        joshhaberman: Crawler::Handlers::Joshhaberman,
        mbuffett: Crawler::Handlers::Mbuffett,
        speedshop: Crawler::Handlers::Speedshop,
        bigbinary: Crawler::Handlers::Bigbinary,
        arkency: Crawler::Handlers::Arkency,
        chrisseaton: Crawler::Handlers::Chrisseaton,
        uber: Crawler::Handlers::Uber,
        tejasbubane: Crawler::Handlers::Tejasbubane,
        josefstrzibny: Crawler::Handlers::Josefstrzibny,
        burke: Crawler::Handlers::Burke,
        wjwh: Crawler::Handlers::Wjwh,
        timriley: Crawler::Handlers::Timriley,
        rubyyagi: Crawler::Handlers::Rubyyagi,
        joyfulbikeshedding: Crawler::Handlers::Joyfulbikeshedding,
        aaronpatterson: Crawler::Handlers::Aaronpatterson,
        noteflakes: Crawler::Handlers::Noteflakes,
        idiosyncraticruby: Crawler::Handlers::Idiosyncraticruby,
        meta: Crawler::Handlers::Meta,
        ivanvelichko: Crawler::Handlers::Ivanvelichko,
        samwilliams: Crawler::Handlers::Samwilliams,
        remimercier: Crawler::Handlers::Remimercier,
        brandur: Crawler::Handlers::Brandur,
        howthingswork: Crawler::Handlers::Howthingswork,
        eregon: Crawler::Handlers::Eregon,
        thoughtbot: Crawler::Handlers::Thoughtbot,
        appsignal: Crawler::Handlers::Appsignal
      }.freeze

      def call(codename)
        Maybe(HANDLERS[codename.to_sym]).fmap { |handler| Success(handler.new) }.value_or(Failure(msg: :unknown_handler))
      end
    end
  end
end
