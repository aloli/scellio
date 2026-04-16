class DocumentHandler < Marten::Handler
  include Auth::RequireSignedInUser

  def get
    request_id = params["request_id"].to_s.to_i64
    deposit_id = params["deposit_id"].to_s.to_i64

    user = request.user!.as(Auth::User)
    req = Request.get!(id: request_id)
    deposit = Deposit.get!(id: deposit_id)

    # Vérifier que l'utilisateur a accès (même organisation)
    if req.organization_id != user.organization_id
      return Marten::HTTP::Response.new(content: "Accès refusé", content_type: "text/plain", status: 403)
    end

    # Marquer comme vu
    if deposit.viewed_at.nil?
      deposit.viewed_at = Time.local
      deposit.save!

      # Logger l'action
      Services::AuditLogger.log(
        action: "document_viewed",
        organization: req.organization,
        user: user,
        request: req,
        ip_address: request.host,
      )
    end

    render("documents/view.html", context: {
      request: req,
      deposit: deposit,
    })
  end
end
