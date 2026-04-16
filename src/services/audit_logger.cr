module Services
  class AuditLogger
    # Enregistre une action dans le journal d'audit
    def self.log(
      action : String,
      organization : Organization? = nil,
      user : Auth::User? = nil,
      request : Request? = nil,
      ip_address : String? = nil,
      user_agent : String? = nil,
      details : Hash(String, String)? = nil,
    ) : AuditLog
      log = AuditLog.new(
        action: action,
        organization: organization,
        user: user,
        request: request,
        ip_address: ip_address,
        user_agent: user_agent,
      )
      log.save!
      log
    end
  end
end
