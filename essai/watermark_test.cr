#!/usr/bin/env crystal

# Teste le filigranage des fichiers originaux avec crystal-watermark
# Usage : crystal run essai/watermark_test.cr

require "crystal-watermark/src/crystal_watermark"

WATERMARK_TEXT = "Remis à SuperBocaux — 15 avril 2026\nCréation compte fournisseur"

Dir.mkdir_p("essai/watermarked")

# --- Filigranage des images PNG ---

puts "=== Filigranage des images ==="

# Style diagonal (défaut)
CrystalWatermark.apply(
  input: "essai/originals/facture.png",
  output: "essai/watermarked/facture-diagonal.png",
  text: WATERMARK_TEXT,
  style: CrystalWatermark::Style::Diagonal
)
puts "✓ facture-diagonal.png"

# Style tiled (mosaïque — plus sécurisé)
CrystalWatermark.apply(
  input: "essai/originals/facture.png",
  output: "essai/watermarked/facture-tiled.png",
  text: WATERMARK_TEXT,
  style: CrystalWatermark::Style::Tiled
)
puts "✓ facture-tiled.png"

# Style header
CrystalWatermark.apply(
  input: "essai/originals/facture.png",
  output: "essai/watermarked/facture-header.png",
  text: WATERMARK_TEXT,
  style: CrystalWatermark::Style::Header
)
puts "✓ facture-header.png"

# Style footer
CrystalWatermark.apply(
  input: "essai/originals/facture.png",
  output: "essai/watermarked/facture-footer.png",
  text: WATERMARK_TEXT,
  style: CrystalWatermark::Style::Footer
)
puts "✓ facture-footer.png"

# Style center
CrystalWatermark.apply(
  input: "essai/originals/facture.png",
  output: "essai/watermarked/facture-center.png",
  text: WATERMARK_TEXT,
  style: CrystalWatermark::Style::Center
)
puts "✓ facture-center.png"

# Photo d'identité — diagonal
CrystalWatermark.apply(
  input: "essai/originals/photo-identite.png",
  output: "essai/watermarked/photo-identite-diagonal.png",
  text: "Remis à SuperBocaux — Usage exclusif",
  style: CrystalWatermark::Style::Diagonal
)
puts "✓ photo-identite-diagonal.png"

# Photo d'identité — tiled (plus difficile à retirer)
CrystalWatermark.apply(
  input: "essai/originals/photo-identite.png",
  output: "essai/watermarked/photo-identite-tiled.png",
  text: "SuperBocaux — 15/04/2026",
  style: CrystalWatermark::Style::Tiled,
  options: CrystalWatermark::Options.new(
    font_size: 24,
    opacity: 0.20,
    color: {0.8, 0.1, 0.1}  # Rouge
  )
)
puts "✓ photo-identite-tiled.png"

puts "\n=== Résumé ==="
Dir.glob("essai/watermarked/*.png").sort.each do |f|
  puts "  #{File.basename(f)} (#{File.size(f)} octets)"
end

puts "\n✓ Tous les fichiers filigranés ont été générés dans essai/watermarked/"
puts "\nNOTE : Le filigranage PDF sera disponible après l'ajout du PDF::Reader dans crystal-pdf."
