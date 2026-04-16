# Gestionnaire public de telechargement des documents filigranes (scenatio B)
# Le demandeur accede via un lien avec token, sans authentification.
class DownloadHandler < Marten::Handler
  def get
    token = params["token"].to_s
    req = Request.filter(token: token).first

    if req.nil?
      return render("download/not_found.html", status: 404)
    end

    if req.status == "purged"
      return render("download/purged.html")
    end

    deposits = Deposit.filter(request: req).to_a

    render("download/view.html", context: {
      request:  req,
      deposits: deposits,
    })
  end
end
