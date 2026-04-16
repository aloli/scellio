# Schéma de validation du formulaire de création de demande
class RequestCreateSchema < Marten::Schema
  field :recipient_email, :email
  field :recipient_name, :string, max_size: 255, required: false
  field :purpose, :string, max_size: 500
  field :message, :string, max_size: 2000, required: false
end
