# Gestionnaire public du dépot de documents (scénario A)
# Le déposant accède via un lien avec token, sans authentification.
class DepositHandler < Marten::Handler
  def get
    token = params["token"].to_s
    req = Request.filter(token: token).first

    if req.nil?
      return render("deposit/not_found.html", status: 404)
    end

    if req.status == "purged"
      return render("deposit/purged.html")
    end

    if req.expires_at.not_nil! < Time.local
      return render("deposit/expired.html")
    end

    render("deposit/form.html", context: {
      request:      req,
      organization: req.organization,
    })
  end

  def post
    token = params["token"].to_s
    req = Request.filter(token: token).first

    return render("deposit/not_found.html", status: 404) if req.nil?
    return render("deposit/expired.html") if req.expires_at.not_nil! < Time.local

    # Phase 1 : mise a jour du statut sans traitement de fichiers.
    # Phase 2 : upload, chiffrement et stockage des fichiers.
    req.status = "deposited"
    req.save!

    render("deposit/confirmation.html", context: {
      request:      req,
      organization: req.organization,
    })
  end
end
