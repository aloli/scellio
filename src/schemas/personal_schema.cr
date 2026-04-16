# Schéma de validation du formulaire de l'espace personnel.
class PersonalSchema < Marten::Schema
  field :recipient_email, :email
  field :recipient_name, :string, max_size: 255, required: false
  field :watermark_text, :string, max_size: 1000
  field :purpose, :string, max_size: 500, required: false
  field :sender_email, :email, required: false
  field :sender_name, :string, max_size: 255, required: false
end
