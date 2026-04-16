# Gestionnaire du détail d'une demande
class RequestDetailHandler < Marten::Handler
  include Auth::RequireSignedInUser

  def get
    user = request.user!.as(Auth::User)
    org = user.organization

    req = Request.filter(organization: org, id: params["id"]).first
    return head 404 if req.nil?

    # Dépôts associés à cette demande
    deposits = Deposit.filter(request: req).order("-created_at").to_a

    render("requests/show.html", context: {
      req:          req,
      deposits:     deposits,
      organization: org,
    })
  end
end
