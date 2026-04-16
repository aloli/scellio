# Modèle représentant une demande de transmission de documents
class Request < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :token, :string, max_size: 255, unique: true
  field :initiated_by, :string, max_size: 50
  field :recipient_email, :string, max_size: 255
  field :recipient_name, :string, max_size: 255, blank: true, null: true
  field :sender_email, :string, max_size: 255, blank: true, null: true
  field :sender_name, :string, max_size: 255, blank: true, null: true
  field :purpose, :string, max_size: 500
  field :watermark_text, :text, blank: true, null: true
  field :message, :text, blank: true, null: true
  field :status, :string, max_size: 50, default: "pending"
  field :expires_at, :date_time
  field :purge_at, :date_time
  field :locale, :string, max_size: 10, default: "fr"
  field :created_at, :date_time, auto_now_add: true
  field :updated_at, :date_time, auto_now: true
  field :organization, :many_to_one, to: Organization, null: true, blank: true
  field :created_by, :many_to_one, to: Auth::User, null: true, blank: true, related: :created_requests
end
