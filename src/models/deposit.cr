# Modèle représentant un document déposé dans le cadre d'une demande
class Deposit < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :original_filename, :string, max_size: 500
  field :content_type, :string, max_size: 255
  field :encrypted_path, :string, max_size: 1000
  field :file_size, :int
  field :watermark_text, :string, max_size: 1000
  field :deposited_at, :date_time
  field :viewed_at, :date_time, blank: true, null: true
  field :downloaded_at, :date_time, blank: true, null: true
  field :purged_at, :date_time, blank: true, null: true
  field :created_at, :date_time, auto_now_add: true
  field :request, :many_to_one, to: Request
  field :document_type, :many_to_one, to: DocumentType, null: true, blank: true
end
