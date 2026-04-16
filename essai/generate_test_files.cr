#!/usr/bin/env crystal

# Génère les fichiers originaux de test pour les essais de filigranage
# Usage : crystal run essai/generate_test_files.cr

require "crystal-pdf/src/pdf"
require "stumpy_png"

# Vérifier qu'on dispose bien des dépendances via crystal-pdf
# On utilise ses dépendances indirectement

module TestGenerator
  # --- PNG : document simulé (facture) ---
  def self.generate_document_png(path : String)
    canvas = StumpyPNG::Canvas.new(800, 1100)

    # Fond blanc
    800.times do |x|
      1100.times do |y|
        canvas[x, y] = StumpyPNG::RGBA.new(0xFFFF_u16, 0xFFFF_u16, 0xFFFF_u16, 0xFFFF_u16)
      end
    end

    # Bande d'en-tête bleue
    800.times do |x|
      80.times do |y|
        canvas[x, y] = StumpyPNG::RGBA.new(0x1B00_u16, 0x2A00_u16, 0x4A00_u16, 0xFFFF_u16)
      end
    end

    # Rectangle gris (zone de texte simulée)
    (50...750).each do |x|
      (120...300).each do |y|
        canvas[x, y] = StumpyPNG::RGBA.new(0xF0F0_u16, 0xF0F0_u16, 0xF0F0_u16, 0xFFFF_u16)
      end
    end

    # Lignes horizontales (simulant du texte)
    (350..900).step(30) do |y|
      (50...700).each do |x|
        if y < 1100
          canvas[x, y.to_i] = StumpyPNG::RGBA.new(0x3333_u16, 0x3333_u16, 0x3333_u16, 0xFFFF_u16)
          canvas[x, y.to_i + 1] = StumpyPNG::RGBA.new(0x3333_u16, 0x3333_u16, 0x3333_u16, 0xFFFF_u16)
        end
      end
    end

    # Petit rectangle rouge (logo simulé)
    (50...150).each do |x|
      (20...60).each do |y|
        canvas[x, y] = StumpyPNG::RGBA.new(0xD400_u16, 0xA800_u16, 0x4B00_u16, 0xFFFF_u16)
      end
    end

    StumpyPNG.write(canvas, path)
    puts "PNG généré : #{path} (#{File.size(path)} octets)"
  end

  # --- PNG : photo d'identité simulée ---
  def self.generate_photo_png(path : String)
    canvas = StumpyPNG::Canvas.new(400, 500)

    # Fond gris clair
    400.times do |x|
      500.times do |y|
        canvas[x, y] = StumpyPNG::RGBA.new(0xEEEE_u16, 0xEEEE_u16, 0xEEEE_u16, 0xFFFF_u16)
      end
    end

    # Cercle (tête simulée)
    200.times do |dx|
      200.times do |dy|
        cx, cy = 200, 180
        dist = Math.sqrt((dx - 100) ** 2 + (dy - 100) ** 2)
        if dist < 80
          canvas[cx - 100 + dx, cy - 100 + dy] = StumpyPNG::RGBA.new(0xDDBB_u16, 0xAA88_u16, 0x8866_u16, 0xFFFF_u16)
        end
      end
    end

    # Rectangle (corps simulé)
    (100...300).each do |x|
      (300...480).each do |y|
        canvas[x, y] = StumpyPNG::RGBA.new(0x4444_u16, 0x6666_u16, 0x8888_u16, 0xFFFF_u16)
      end
    end

    StumpyPNG.write(canvas, path)
    puts "PNG généré : #{path} (#{File.size(path)} octets)"
  end

  # --- PDF : une page (Kbis simulé) ---
  def self.generate_kbis_pdf(path : String)
    pdf = PDF::Document.new
    pdf.title = "Extrait Kbis — SuperBocaux SAS"

    pdf.page(size: :a4) do |page|
      # En-tête
      page.font("Helvetica-Bold", size: 18)
      page.text("EXTRAIT K BIS", at: {72, 750})

      page.font("Helvetica", size: 10)
      page.text("Greffe du Tribunal de Commerce de Paris", at: {72, 730})
      page.text("Date de l'extrait : 15 avril 2026", at: {72, 715})

      # Ligne de séparation
      page.stroke_color(0.0, 0.0, 0.0)
      page.line_width(1.0)
      page.move_to(72, 700)
      page.line_to(523, 700)
      page.stroke

      # Informations société
      page.font("Helvetica-Bold", size: 12)
      page.text("SuperBocaux SAS", at: {72, 670})

      page.font("Helvetica", size: 10)
      y = 645
      [
        "RCS Paris 123 456 789",
        "SIREN : 123 456 789",
        "SIRET (siège) : 123 456 789 00010",
        "Code APE : 4639B — Commerce de gros alimentaire",
        "",
        "Siège social : 42 rue des Conserves, 75011 Paris",
        "Capital social : 50 000,00 EUR",
        "Date d'immatriculation : 12 mars 2015",
        "",
        "Dirigeant :",
        "  Jean DUPONT — Président",
        "  Né le 15/06/1975 à Lyon (69)",
        "",
        "Activité : Commerce de gros de produits alimentaires,",
        "  conserves et bocaux en verre.",
      ].each do |line|
        page.text(line, at: {72, y}) unless line.empty?
        y -= 15
      end

      # Pied de page
      page.font("Helvetica-Oblique", size: 8)
      page.text("Ce document est un extrait simulé généré pour les tests Scellio.", at: {72, 50})
    end

    pdf.save(path)
    puts "PDF 1 page généré : #{path} (#{File.size(path)} octets)"
  end

  # --- PDF : multi-pages (dossier d'inscription simulé) ---
  def self.generate_dossier_pdf(path : String)
    pdf = PDF::Document.new
    pdf.title = "Dossier d'inscription — SuperBocaux SAS"

    # Page 1 : page de garde
    pdf.page(size: :a4) do |page|
      page.font("Helvetica-Bold", size: 24)
      page.text("DOSSIER D'INSCRIPTION", at: {72, 500})

      page.font("Helvetica", size: 14)
      page.text("SuperBocaux SAS", at: {72, 460})
      page.text("Avril 2026", at: {72, 440})

      page.font("Helvetica", size: 10)
      page.text("Ce dossier contient les pièces justificatives", at: {72, 380})
      page.text("nécessaires à la création du compte fournisseur.", at: {72, 365})
    end

    # Page 2 : informations société
    pdf.page(size: :a4) do |page|
      page.font("Helvetica-Bold", size: 14)
      page.text("1. Informations de la société", at: {72, 750})

      page.font("Helvetica", size: 10)
      y = 720
      [
        "Raison sociale : SuperBocaux SAS",
        "Forme juridique : SAS (Société par Actions Simplifiée)",
        "Capital social : 50 000,00 EUR",
        "Numéro SIREN : 123 456 789",
        "Numéro de TVA : FR 12 123456789",
        "Code APE : 4639B",
        "",
        "Siège social :",
        "  42 rue des Conserves",
        "  75011 Paris",
        "  France",
        "",
        "Téléphone : +33 1 23 45 67 89",
        "Email : contact@superbocaux.fr",
        "Site web : www.superbocaux.fr",
      ].each do |line|
        page.text(line, at: {72, y}) unless line.empty?
        y -= 15
      end
    end

    # Page 3 : coordonnées bancaires
    pdf.page(size: :a4) do |page|
      page.font("Helvetica-Bold", size: 14)
      page.text("2. Coordonnées bancaires", at: {72, 750})

      page.font("Helvetica", size: 10)
      y = 720
      [
        "Banque : Banque Nationale de Paris",
        "IBAN : FR76 3000 1007 9412 3456 7890 185",
        "BIC : BNPAFRPP",
        "",
        "Titulaire du compte : SuperBocaux SAS",
      ].each do |line|
        page.text(line, at: {72, y}) unless line.empty?
        y -= 15
      end

      page.font("Helvetica-Oblique", size: 8)
      page.text("Document simulé pour les tests Scellio — Page 3/3", at: {72, 50})
    end

    pdf.save(path)
    puts "PDF 3 pages généré : #{path} (#{File.size(path)} octets)"
  end
end

# Vérifier que le dossier existe
Dir.mkdir_p("essai/originals")

# Générer tous les fichiers
TestGenerator.generate_document_png("essai/originals/facture.png")
TestGenerator.generate_photo_png("essai/originals/photo-identite.png")
TestGenerator.generate_kbis_pdf("essai/originals/kbis.pdf")
TestGenerator.generate_dossier_pdf("essai/originals/dossier-inscription.pdf")

puts "\n✓ Tous les fichiers de test ont été générés dans essai/originals/"
