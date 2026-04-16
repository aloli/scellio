require "../spec_helper"

describe Services::Purger do
  describe ".purge_expired!" do
    it "retourne 0 quand aucune demande n'est expirée" do
      # Sans données expirées, le compteur doit être à zéro
      count = Services::Purger.purge_expired!
      count.should eq(0)
    end
  end
end
