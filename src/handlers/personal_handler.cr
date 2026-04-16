# Gestionnaire de l'espace personnel (scénario B)
# Permet à un utilisateur non authentifié de filigraner et envoyer un document.
class PersonalHandler < Marten::Handler
  def get
    render("personal/form.html")
  end

  def post
    # Phase 1 : rendu de la confirmation sans traitement réel.
    # Phase 2 : upload, filigranage, envoi par email.
    render("personal/confirmation.html", context: {
      recipient_email: request.data["recipient_email"]?,
      watermark_text:  request.data["watermark_text"]?,
    })
  end
end
