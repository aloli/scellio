module Auth
  class User < MartenAuth::User
    field :role, :string, max_size: 50, default: "member"
    field :locale, :string, max_size: 10, blank: true, null: true
    field :organization, :many_to_one, to: Organization, null: true, blank: true
  end
end
