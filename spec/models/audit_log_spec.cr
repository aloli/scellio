require "../spec_helper"

describe AuditLog do
  before_each do
    @org = Organization.create!(
      name: "Test Org",
      slug: "test-org-al-#{Random::Secure.hex(4)}",
      email: "test@org.com"
    )
  end

  describe "fields" do
    it "can be created with valid attributes" do
      log = AuditLog.new(
        action: "request.created",
        ip_address: "192.168.1.1",
        organization: @org
      )
      log.action.should eq "request.created"
      log.ip_address.should eq "192.168.1.1"
    end

    it "allows nullable ip_address" do
      log = AuditLog.create!(action: "system.cleanup")
      log.ip_address.should be_nil
    end

    it "allows nullable user_agent" do
      log = AuditLog.create!(action: "system.purge")
      log.user_agent.should be_nil
    end

    it "allows nullable details" do
      log = AuditLog.create!(action: "system.task")
      log.details.should be_nil
    end

    it "allows nullable organization" do
      log = AuditLog.create!(action: "individual.upload")
      log.organization.should be_nil
    end

    it "allows nullable user" do
      log = AuditLog.create!(action: "anonymous.action")
      log.user.should be_nil
    end

    it "allows nullable request" do
      log = AuditLog.create!(action: "global.action")
      log.request.should be_nil
    end

    it "belongs to organization when set" do
      log = AuditLog.create!(
        action: "org.action",
        organization: @org
      )
      log.organization.should eq @org
    end
  end
end
