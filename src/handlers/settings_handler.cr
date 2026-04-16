# Gestionnaire des paramètres de l'organisation
class SettingsHandler < Marten::Handler
  include Auth::RequireSignedInUser

  def get
    user = request.user!.as(Auth::User)
    org = user.organization

    document_types = DocumentType.filter(organization: org).order("position").to_a

    render("settings/index.html", context: {
      organization:   org,
      document_types: document_types,
    })
  end

  def post
    user = request.user!.as(Auth::User)
    org = user.organization

    # Ajout d'un type de document
    name = request.data["name"]?
    if name && !name.to_s.empty?
      description = request.data["description"]?.to_s
      is_mandatory = request.data["is_mandatory"]? == "on"
      position = DocumentType.filter(organization: org).count.to_i32

      doc_type = DocumentType.new(
        name: name.to_s,
        description: description,
        is_mandatory: is_mandatory,
        position: position,
        organization: org,
      )
      doc_type.save!

      flash[:success] = "Type de document ajouté."
    else
      flash[:error] = "Le nom du type de document est obligatoire."
    end

    redirect reverse("settings")
  end
end
