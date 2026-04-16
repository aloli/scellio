class PricingHandler < Marten::Handler
  def get
    render("site/pricing.html")
  end
end
