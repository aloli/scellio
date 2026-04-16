# Gestionnaire de la liste des demandes
class RequestListHandler < Marten::Handler
  include Auth::RequireSignedInUser

  def get
    user = request.user!.as(Auth::User)
    org = user.organization

    requests = Request.filter(organization: org).order("-created_at").to_a

    render("requests/list.html", context: {
      organization: org,
      requests:     requests,
    })
  end
end
