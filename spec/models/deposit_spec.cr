require "../spec_helper"

describe Deposit do
  before_each do
    @org = Organization.create!(
      name: "Test Org",
      slug: "test-org-dep-#{Random::Secure.hex(4)}",
      email: "test@org.com"
    )
    @request = Request.create!(
      token: "tok_#{Random::Secure.hex(16)}",
      initiated_by: "organization",
      recipient_email: "recipient@test.com",
      purpose: "Collecte de documents",
      expires_at: Time.utc + 7.days,
      purge_at: Time.utc + 30.days,
      organization: @org
    )
  end

  describe "fields" do
    it "can be created with valid attributes" do
      deposit = Deposit.new(
        original_filename: "carte_identite.pdf",
        content_type: "application/pdf",
        encrypted_path: "/vault/enc/abc123.enc",
        file_size: 1024000,
        watermark_text: "Réservé à Acme Corp - 13/04/2026",
        deposited_at: Time.utc,
        request: @request
      )
      deposit.original_filename.should eq "carte_identite.pdf"
      deposit.content_type.should eq "application/pdf"
      deposit.file_size.should eq 1024000
    end

    it "belongs to a request" do
      deposit = Deposit.create!(
        original_filename: "rib.pdf",
        content_type: "application/pdf",
        encrypted_path: "/vault/enc/def456.enc",
        file_size: 512000,
        watermark_text: "Confidentiel",
        deposited_at: Time.utc,
        request: @request
      )
      deposit.request.should eq @request
    end

    it "allows nullable document_type (scenario B)" do
      deposit = Deposit.create!(
        original_filename: "document.pdf",
        content_type: "application/pdf",
        encrypted_path: "/vault/enc/ghi789.enc",
        file_size: 256000,
        watermark_text: "Filigrane",
        deposited_at: Time.utc,
        request: @request
      )
      deposit.document_type.should be_nil
    end

    it "allows nullable viewed_at, downloaded_at, purged_at" do
      deposit = Deposit.create!(
        original_filename: "kbis.pdf",
        content_type: "application/pdf",
        encrypted_path: "/vault/enc/jkl012.enc",
        file_size: 128000,
        watermark_text: "Copie",
        deposited_at: Time.utc,
        request: @request
      )
      deposit.viewed_at.should be_nil
      deposit.downloaded_at.should be_nil
      deposit.purged_at.should be_nil
    end
  end
end
