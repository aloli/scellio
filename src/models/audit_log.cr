# Modèle représentant une entrée de journal d'audit
class AuditLog < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :action, :string, max_size: 255
  field :ip_address, :string, max_size: 50, blank: true, null: true
  field :user_agent, :text, blank: true, null: true
  field :details, :json, blank: true, null: true
  field :created_at, :date_time, auto_now_add: true
  field :organization, :many_to_one, to: Organization, null: true, blank: true
  field :user, :many_to_one, to: Auth::User, null: true, blank: true, related: :audit_logs
  field :request, :many_to_one, to: Request, null: true, blank: true, related: :audit_logs
end
