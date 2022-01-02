# frozen_string_literal: true

module Application
  module Contracts
    class UnsubscriptionContract < Dry::Validation::Contract
      include Import['application.ports.repositories.chat_repo']

      params do
        required(:chat_uid).filled(:string)
        required(:blog_codename).filled(:string)
      end

      rule(:chat_uid, :blog_codename) do
        key.failure('subscription is not present') unless chat_repo.subscription_exists?(values[:chat_uid], values[:blog_codename])
      end
    end
  end
end
