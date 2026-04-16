require "../spec_helper"

describe Services::AuditLogger do
  describe ".log" do
    it "crée une entrée de journal d'audit avec l'action spécifiée" do
      log = Services::AuditLogger.log(
        action: "test_action",
        ip_address: "127.0.0.1",
        user_agent: "TestAgent/1.0",
      )

      log.persisted?.should be_true
      log.action.should eq("test_action")
      log.ip_address.should eq("127.0.0.1")
      log.user_agent.should eq("TestAgent/1.0")
    end

    it "crée une entrée sans paramètres optionnels" do
      log = Services::AuditLogger.log(action: "minimal_action")

      log.persisted?.should be_true
      log.action.should eq("minimal_action")
      log.organization.should be_nil
      log.user.should be_nil
      log.request.should be_nil
    end
  end
end
