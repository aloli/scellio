require "../spec_helper"

describe Subscription do
  before_each do
    @org = Organization.create!(
      name: "Test Org",
      slug: "test-org-sub-#{Random::Secure.hex(4)}",
      email: "test@org.com"
    )
  end

  describe "fields" do
    it "can be created with valid attributes" do
      sub = Subscription.new(
        plan: "pro",
        payment_method: "stripe_card",
        external_id: "sub_123456",
        current_period_start: Time.utc,
        current_period_end: Time.utc + 30.days,
        organization: @org
      )
      sub.plan.should eq "pro"
      sub.payment_method.should eq "stripe_card"
      sub.external_id.should eq "sub_123456"
    end

    it "has default status 'active'" do
      sub = Subscription.new(
        plan: "starter",
        payment_method: "stripe_sepa",
        external_id: "sub_789",
        current_period_start: Time.utc,
        current_period_end: Time.utc + 30.days,
        organization: @org
      )
      sub.status.should eq "active"
    end

    it "belongs to an organization" do
      sub = Subscription.create!(
        plan: "enterprise",
        payment_method: "paypal",
        external_id: "sub_ent_001",
        current_period_start: Time.utc,
        current_period_end: Time.utc + 365.days,
        organization: @org
      )
      sub.organization.should eq @org
    end
  end
end
