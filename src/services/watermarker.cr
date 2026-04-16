require "crystal-watermark/src/crystal_watermark"

module Services
  class Watermarker
    # Applique un filigrane sur un fichier et retourne le chemin du fichier filigrané
    def self.apply(input_path : String, organization_name : String, purpose : String, date : Time) : String
      output_path = input_path.gsub(/(\.\w+)$/, "-watermarked\\1")

      watermark_text = "Remis à #{organization_name} — #{date.to_s("%d/%m/%Y")}\n#{purpose}"

      ext = File.extname(input_path).downcase
      case ext
      when ".pdf"
        CrystalWatermark.apply(
          input: input_path,
          output: output_path,
          text: watermark_text,
          style: CrystalWatermark::Style::Diagonal
        )
      when ".png", ".jpg", ".jpeg"
        CrystalWatermark.apply(
          input: input_path,
          output: output_path,
          text: watermark_text,
          style: CrystalWatermark::Style::Diagonal
        )
      else
        raise "Format non supporté : #{ext}"
      end

      output_path
    end
  end
end
