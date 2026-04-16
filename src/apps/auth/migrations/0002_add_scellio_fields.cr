# Ajout des champs Scellio sur le modèle Auth::User
class Migration::Auth::V0002AddScellioFields < Marten::Migration
  depends_on "auth", "0001_create_auth_user_table"
  depends_on "main", "0001_create_scellio_tables"

  def plan
    add_column :auth_user, :role, :string, max_size: 50, default: "member"
    add_column :auth_user, :locale, :string, max_size: 10, null: true
    add_column :auth_user, :organization_id, :big_int, null: true
  end
end
