class HowItWorksHandler < Marten::Handler
  def get
    render("site/how_it_works.html")
  end
end
