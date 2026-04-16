# Modèle représentant un type de document attendu dans une demande
class DocumentType < Marten::Model
  field :id, :big_int, primary_key: true, auto: true
  field :name, :string, max_size: 255
  field :description, :text, blank: true, null: true
  field :is_mandatory, :bool, default: true
  field :position, :int, default: 0
  field :organization, :many_to_one, to: Organization
end
