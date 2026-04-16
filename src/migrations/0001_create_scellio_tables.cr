# Migration initiale : création des tables métier Scellio
class Migration::Scellio::V0001CreateScellioTables < Marten::Migration
  depends_on "auth", "0001_create_auth_user_table"

  def plan
    create_table :organization do
      column :id, :big_int, primary_key: true, auto: true
      column :name, :string, max_size: 255
      column :slug, :string, max_size: 100, unique: true
      column :email, :string, max_size: 255
      column :plan, :string, max_size: 50, default: "free"
      column :requests_count, :int, default: 0
      column :locale, :string, max_size: 10, default: "fr"
      column :created_at, :date_time
      column :updated_at, :date_time
    end

    create_table :subscription do
      column :id, :big_int, primary_key: true, auto: true
      column :plan, :string, max_size: 50
      column :payment_method, :string, max_size: 50
      column :external_id, :string, max_size: 255
      column :status, :string, max_size: 50, default: "active"
      column :current_period_start, :date_time
      column :current_period_end, :date_time
      column :created_at, :date_time
      column :updated_at, :date_time
      column :organization_id, :big_int
    end

    create_table :document_type do
      column :id, :big_int, primary_key: true, auto: true
      column :name, :string, max_size: 255
      column :description, :text, null: true
      column :is_mandatory, :bool, default: true
      column :position, :int, default: 0
      column :organization_id, :big_int
    end

    create_table :request do
      column :id, :big_int, primary_key: true, auto: true
      column :token, :string, max_size: 255, unique: true
      column :initiated_by, :string, max_size: 50
      column :recipient_email, :string, max_size: 255
      column :recipient_name, :string, max_size: 255, null: true
      column :sender_email, :string, max_size: 255, null: true
      column :sender_name, :string, max_size: 255, null: true
      column :purpose, :string, max_size: 500
      column :watermark_text, :text, null: true
      column :message, :text, null: true
      column :status, :string, max_size: 50, default: "pending"
      column :expires_at, :date_time
      column :purge_at, :date_time
      column :locale, :string, max_size: 10, default: "fr"
      column :created_at, :date_time
      column :updated_at, :date_time
      column :organization_id, :big_int, null: true
      column :created_by_id, :big_int, null: true
    end

    create_table :deposit do
      column :id, :big_int, primary_key: true, auto: true
      column :original_filename, :string, max_size: 500
      column :content_type, :string, max_size: 255
      column :encrypted_path, :string, max_size: 1000
      column :file_size, :int
      column :watermark_text, :string, max_size: 1000
      column :deposited_at, :date_time
      column :viewed_at, :date_time, null: true
      column :downloaded_at, :date_time, null: true
      column :purged_at, :date_time, null: true
      column :created_at, :date_time
      column :request_id, :big_int
      column :document_type_id, :big_int, null: true
    end

    create_table :audit_log do
      column :id, :big_int, primary_key: true, auto: true
      column :action, :string, max_size: 255
      column :ip_address, :string, max_size: 50, null: true
      column :user_agent, :text, null: true
      column :details, :json, null: true
      column :created_at, :date_time
      column :organization_id, :big_int, null: true
      column :user_id, :big_int, null: true
      column :request_id, :big_int, null: true
    end
  end
end
