require "../spec_helper"

describe Request do
  before_each do
    @org = Organization.create!(
      name: "Test Org",
      slug: "test-org-req-#{Random::Secure.hex(4)}",
      email: "test@org.com"
    )
  end

  describe "fields" do
    it "can be created with valid attributes" do
      req = Request.new(
        token: "tok_#{Random::Secure.hex(16)}",
        initiated_by: "organization",
        recipient_email: "recipient@test.com",
        purpose: "Collecte de documents KYC",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days,
        organization: @org
      )
      req.initiated_by.should eq "organization"
      req.recipient_email.should eq "recipient@test.com"
    end

    it "has default status 'pending'" do
      req = Request.new(
        token: "tok_#{Random::Secure.hex(16)}",
        initiated_by: "organization",
        recipient_email: "recipient@test.com",
        purpose: "Vérification d'identité",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days
      )
      req.status.should eq "pending"
    end

    it "has default locale 'fr'" do
      req = Request.new(
        token: "tok_#{Random::Secure.hex(16)}",
        initiated_by: "individual",
        recipient_email: "recipient@test.com",
        purpose: "Envoi sécurisé",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days
      )
      req.locale.should eq "fr"
    end

    it "enforces token uniqueness" do
      token = "tok_unique_#{Random::Secure.hex(8)}"
      Request.create!(
        token: token,
        initiated_by: "organization",
        recipient_email: "r1@test.com",
        purpose: "Test 1",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days,
        organization: @org
      )

      req2 = Request.new(
        token: token,
        initiated_by: "individual",
        recipient_email: "r2@test.com",
        purpose: "Test 2",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days
      )
      req2.valid?.should be_false
    end

    it "allows null organization (scenario B - individual)" do
      req = Request.create!(
        token: "tok_#{Random::Secure.hex(16)}",
        initiated_by: "individual",
        recipient_email: "recipient@test.com",
        sender_email: "sender@test.com",
        sender_name: "Jean Dupont",
        purpose: "Envoi sécurisé de documents",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days
      )
      req.organization.should be_nil
    end

    it "accepts initiated_by 'organization'" do
      req = Request.new(
        token: "tok_#{Random::Secure.hex(16)}",
        initiated_by: "organization",
        recipient_email: "r@test.com",
        purpose: "Test",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days,
        organization: @org
      )
      req.initiated_by.should eq "organization"
    end

    it "accepts initiated_by 'individual'" do
      req = Request.new(
        token: "tok_#{Random::Secure.hex(16)}",
        initiated_by: "individual",
        recipient_email: "r@test.com",
        purpose: "Test",
        expires_at: Time.utc + 7.days,
        purge_at: Time.utc + 30.days
      )
      req.initiated_by.should eq "individual"
    end
  end
end
