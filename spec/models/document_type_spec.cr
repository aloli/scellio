require "../spec_helper"

describe DocumentType do
  before_each do
    @org = Organization.create!(
      name: "Test Org",
      slug: "test-org-dt-#{Random::Secure.hex(4)}",
      email: "test@org.com"
    )
  end

  describe "fields" do
    it "can be created with valid attributes" do
      dt = DocumentType.new(
        name: "Kbis",
        organization: @org
      )
      dt.name.should eq "Kbis"
    end

    it "has default is_mandatory true" do
      dt = DocumentType.new(
        name: "Pièce d'identité",
        organization: @org
      )
      dt.is_mandatory.should be_true
    end

    it "has default position 0" do
      dt = DocumentType.new(
        name: "RIB",
        organization: @org
      )
      dt.position.should eq 0
    end

    it "belongs to an organization" do
      dt = DocumentType.create!(
        name: "Kbis",
        organization: @org
      )
      dt.organization.should eq @org
    end
  end
end
