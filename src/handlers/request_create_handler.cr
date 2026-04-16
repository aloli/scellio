# Gestionnaire de création de demande
class RequestCreateHandler < Marten::Handler
  include Auth::RequireSignedInUser

  def get
    user = request.user!.as(Auth::User)
    org = user.organization
    schema = RequestCreateSchema.new(Marten::Schema::DataHash.new)

    # Types de documents disponibles pour cette organisation
    document_types = DocumentType.filter(organization: org).order("position").to_a

    render("requests/new.html", context: {
      schema:         schema,
      document_types: document_types,
      organization:   org,
    })
  end

  def post
    user = request.user!.as(Auth::User)
    org = user.organization
    schema = RequestCreateSchema.new(request.data)
    document_types = DocumentType.filter(organization: org).order("position").to_a

    if schema.valid?
      # Création de la demande
      new_request = Request.new(
        token: Random::Secure.hex(32),
        initiated_by: "organization",
        recipient_email: schema["recipient_email"].to_s,
        recipient_name: schema["recipient_name"].to_s,
        purpose: schema["purpose"].to_s,
        message: schema["message"].to_s,
        status: "pending",
        expires_at: Time.local + 7.days,
        purge_at: Time.local + 14.days,
        organization: org,
        created_by: user,
      )
      new_request.save!

      flash[:success] = "Demande envoyée avec succès."
      redirect reverse("request_detail", id: new_request.id)
    else
      render("requests/new.html", context: {
        schema:         schema,
        document_types: document_types,
        organization:   org,
      }, status: 422)
    end
  end
end
