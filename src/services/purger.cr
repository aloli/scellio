module Services
  class Purger
    # Supprime les fichiers des demandes dont la date de purge est dépassée
    def self.purge_expired! : Int32
      count = 0

      requests = Request.filter(status__in: ["deposited", "viewed", "downloaded"])
      requests.each do |req|
        next unless req.purge_at < Time.local

        # Supprimer les fichiers physiques
        deposits = Deposit.filter(request: req)
        deposits.each do |deposit|
          if File.exists?(deposit.encrypted_path)
            File.delete(deposit.encrypted_path)
          end
          deposit.purged_at = Time.local
          deposit.save!
        end

        req.status = "purged"
        req.save!
        count += 1
      end

      count
    end
  end
end
