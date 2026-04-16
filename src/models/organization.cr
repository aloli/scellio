# Modèle représentant une organisation (entreprise, cabinet, etc.)
class Organization < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :name, :string, max_size: 255
  field :slug, :string, max_size: 100, unique: true
  field :email, :string, max_size: 255
  field :plan, :string, max_size: 50, default: "free"
  field :requests_count, :int, default: 0
  field :locale, :string, max_size: 10, default: "fr"
  field :created_at, :date_time, auto_now_add: true
  field :updated_at, :date_time, auto_now: true
end
