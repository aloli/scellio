# The main routes map associates routes to handlers.
# For more information please see: https://martenframework.com/docs/handlers-and-http/routing
Marten.routes.draw do
  path "/", HomeHandler, name: "home"
  path "/comment-ca-marche", HowItWorksHandler, name: "how_it_works"
  path "/tarifs", PricingHandler, name: "pricing"
  path "/personnel", PersonalHandler, name: "personal"

  # Organisation : tableau de bord, demandes, paramètres
  path "/tableau-de-bord", DashboardHandler, name: "dashboard"
  path "/demandes/nouvelle", RequestCreateHandler, name: "request_create"
  path "/demandes/<id:int>", RequestDetailHandler, name: "request_detail"
  path "/demandes", RequestListHandler, name: "request_list"
  path "/parametres", SettingsHandler, name: "settings"

  path "/demandes/<request_id:int>/documents/<deposit_id:int>", DocumentHandler, name: "document_view"

  # Depot et telechargement publics (sans authentification)
  path "/depot/<token:str>", DepositHandler, name: "deposit"
  path "/telecharger/<token:str>", DownloadHandler, name: "download"

  path "/auth", Auth::ROUTES, name: "auth"

  if Marten.env.development?
    path "#{Marten.settings.assets.url}<path:path>", Marten::Handlers::Defaults::Development::ServeAsset, name: "asset"
    path "#{Marten.settings.media_files.url}<path:path>", Marten::Handlers::Defaults::Development::ServeMediaFile, name: "media_file"
  end
end
