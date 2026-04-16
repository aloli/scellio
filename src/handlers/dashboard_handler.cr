# Gestionnaire du tableau de bord organisation
class DashboardHandler < Marten::Handler
  include Auth::RequireSignedInUser

  def get
    user = request.user!.as(Auth::User)
    org = user.organization

    # Récupération des demandes récentes
    requests = Request.filter(organization: org).order("-created_at").to_a[0..9]

    # Statistiques
    total_requests = Request.filter(organization: org).count
    pending_requests = Request.filter(organization: org, status: "pending").count
    deposited_requests = Request.filter(organization: org, status: "deposited").count

    render("dashboard/index.html", context: {
      organization:       org,
      requests:           requests,
      total_requests:     total_requests,
      pending_requests:   pending_requests,
      deposited_requests: deposited_requests,
    })
  end
end
