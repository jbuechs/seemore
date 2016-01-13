FactoryGirl.define do
  factory :twitter_creator, class: Creator do
    p_id 154915030
    username "stillkidrauhl"
    provider "twitter"
  end

  factory :vimeo_creator, class: Creator do
    p_id 2699352
    username "HELLO, SAVANTS!"
    provider "vimeo"
  end

  factory :developer_user, class: User do
    name "Ada Lovelace"
    uid 1234
    provider "developer"
  end

  factory :user, class: User do
    name "Ada"
    uid "1234"
    provider "twitter"
  end
end
