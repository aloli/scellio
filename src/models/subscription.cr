# Modèle représentant un abonnement lié à une organisation
class Subscription < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :plan, :string, max_size: 50
  field :payment_method, :string, max_size: 50
  field :external_id, :string, max_size: 255
  field :status, :string, max_size: 50, default: "active"
  field :current_period_start, :date_time
  field :current_period_end, :date_time
  field :created_at, :date_time, auto_now_add: true
  field :updated_at, :date_time, auto_now: true
  field :organization, :many_to_one, to: Organization
end
