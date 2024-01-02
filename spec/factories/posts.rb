# spec/factories/posts.rb

FactoryBot.define do
    factory :post do
        body { Faker::Lorem.paragraph }
        user_id { create(:user).id } # Assuming you have a :user factory
        created_at { Faker::Time.between(from: 7.days.ago, to: Time.now) }
        updated_at { created_at }
        post_id { nil } # Assuming you want to leave it as nil
        parent_post_id { nil } # Assuming you want to leave it as nil
        datathing_id { nil } # Assuming you want to leave it as nil
        post_category_id { nil } # Assuming you want to leave it as nil
        q1 { Faker::Lorem.sentence }
        q1_type { nil } # Change this to the desired value
        q1_args { "Yes,No,Maybe" }
        q1_percentages { "1,2,4" }
        q2 { Faker::Lorem.sentence }
        q2_type { nil } # Change this to the desired value
        q2_args { "Yes,No,Maybe" }
        q2_percentages { "8,2,4" }
        likes { 0 } # Change this to the desired value
        image_link { nil }
        video_link { nil }
        is_private { false } # Change this to true if needed
        organization_id { nil } # Assuming you want to leave it as nil
        datathing { Faker::Lorem.paragraph }
        form_link { nil }   #Faker::Internet.url
        moderation_status { "pending" }
        post_category { ["information"] } # Empty array by default
    end
  end