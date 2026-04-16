#!/usr/bin/env crystal

# Teste le filigranage des fichiers PDF avec crystal-watermark
# Usage : crystal run watermark_pdf_test.cr

require "crystal-watermark/src/crystal_watermark"

WATERMARK_TEXT = "Remis à SuperBocaux — 15 avril 2026\nCréation compte fournisseur"

Dir.mkdir_p("originals")
Dir.mkdir_p("watermarked")

puts "=== Filigranage des PDF ==="

# Kbis (1 page) — diagonal
CrystalWatermark.apply(
  input: "originals/kbis.pdf",
  output: "watermarked/kbis-diagonal.pdf",
  text: WATERMARK_TEXT,
  style: CrystalWatermark::Style::Diagonal
)
puts "✓ kbis-diagonal.pdf (#{File.size("watermarked/kbis-diagonal.pdf")} octets)"

# Kbis (1 page) — tiled
CrystalWatermark.apply(
  input: "originals/kbis.pdf",
  output: "watermarked/kbis-tiled.pdf",
  text: "SuperBocaux — Usage exclusif",
  style: CrystalWatermark::Style::Tiled,
  options: CrystalWatermark::Options.new(
    font_size: 24,
    opacity: 0.12
  )
)
puts "✓ kbis-tiled.pdf (#{File.size("watermarked/kbis-tiled.pdf")} octets)"

# Dossier inscription (3 pages) — diagonal
CrystalWatermark.apply(
  input: "originals/dossier-inscription.pdf",
  output: "watermarked/dossier-diagonal.pdf",
  text: WATERMARK_TEXT,
  style: CrystalWatermark::Style::Diagonal
)
puts "✓ dossier-diagonal.pdf (#{File.size("watermarked/dossier-diagonal.pdf")} octets)"

# Dossier inscription (3 pages) — footer
CrystalWatermark.apply(
  input: "originals/dossier-inscription.pdf",
  output: "watermarked/dossier-footer.pdf",
  text: "Document transmis via Scellio — Usage exclusif : création compte fournisseur",
  style: CrystalWatermark::Style::Footer,
  options: CrystalWatermark::Options.new(
    font_size: 10,
    opacity: 0.5,
    color: {0.3, 0.3, 0.3}
  )
)
puts "✓ dossier-footer.pdf (#{File.size("watermarked/dossier-footer.pdf")} octets)"

puts "\n=== Résumé des PDF filigranés ==="
Dir.glob("watermarked/*.pdf").sort.each do |f|
  puts "  #{File.basename(f)} (#{File.size(f)} octets)"
end

puts "\n✓ Tous les PDF filigranés ont été générés dans watermarked/"
