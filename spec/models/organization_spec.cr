require "../spec_helper"

describe Organization do
  describe "fields" do
    it "can be created with valid attributes" do
      org = Organization.new(
        name: "Acme Corp",
        slug: "acme-corp",
        email: "contact@acme.com"
      )
      org.name.should eq "Acme Corp"
      org.slug.should eq "acme-corp"
      org.email.should eq "contact@acme.com"
    end

    it "has default plan 'free'" do
      org = Organization.new(
        name: "Test Org",
        slug: "test-org",
        email: "test@org.com"
      )
      org.plan.should eq "free"
    end

    it "has default locale 'fr'" do
      org = Organization.new(
        name: "Test Org",
        slug: "test-org",
        email: "test@org.com"
      )
      org.locale.should eq "fr"
    end

    it "has default requests_count 0" do
      org = Organization.new(
        name: "Test Org",
        slug: "test-org",
        email: "test@org.com"
      )
      org.requests_count.should eq 0
    end

    it "enforces slug uniqueness" do
      org1 = Organization.create!(
        name: "Org One",
        slug: "unique-slug",
        email: "org1@test.com"
      )

      org2 = Organization.new(
        name: "Org Two",
        slug: "unique-slug",
        email: "org2@test.com"
      )
      org2.valid?.should be_false
    end
  end
end
