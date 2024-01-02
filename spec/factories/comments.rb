# spec/factories/comments.rb

FactoryBot.define do
    factory :comment do
        user
        post
        body { Faker::Lorem.paragraph }
        created_at { Faker::Time.between(from: 7.days.ago, to: Time.now) }
        updated_at { created_at }
        parent_comment { nil }
    end
  end