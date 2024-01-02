# spec/factories/users.rb
FactoryBot.define do
    factory :user do
        email { 'testuser@columbia.edu' }
        password { 'password123' } # You can set a default password
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        username { Faker::Internet.unique.username }
        admin { false }
        is_moderator { false }
    end
end

