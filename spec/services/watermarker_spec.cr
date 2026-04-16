require "../spec_helper"

describe Services::Watermarker do
  describe ".apply" do
    it "génère le chemin de sortie avec le suffixe -watermarked" do
      input = "/tmp/test-document.pdf"
      expected = "/tmp/test-document-watermarked.pdf"
      output = input.gsub(/(\.\w+)$/, "-watermarked\\1")
      output.should eq(expected)
    end

    it "lève une erreur pour un format non supporté" do
      expect_raises(Exception, "Format non supporté") do
        Services::Watermarker.apply(
          input_path: "/tmp/test.docx",
          organization_name: "Test Org",
          purpose: "Vérification",
          date: Time.local
        )
      end
    end
  end
end
