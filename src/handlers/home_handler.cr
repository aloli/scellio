class HomeHandler < Marten::Handler
  def get
    render("site/home.html")
  end
end
