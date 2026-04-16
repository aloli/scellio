require "openssl"

module Services
  class Encryptor
    # Chiffre un fichier et retourne le chemin chiffré + la clé
    def self.encrypt(input_path : String, output_path : String) : {key: String, iv: String}
      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      cipher.encrypt

      key = cipher.random_key
      iv = cipher.random_iv

      data = File.read(input_path).to_slice
      encrypted = cipher.update(data)
      encrypted_final = cipher.final

      File.write(output_path, encrypted + encrypted_final)

      {key: key.hexstring, iv: iv.hexstring}
    end

    # Déchiffre un fichier
    def self.decrypt(input_path : String, output_path : String, key_hex : String, iv_hex : String) : Nil
      cipher = OpenSSL::Cipher.new("aes-256-gcm")
      cipher.decrypt
      cipher.key = key_hex.hexbytes
      cipher.iv = iv_hex.hexbytes

      data = File.read(input_path).to_slice
      decrypted = cipher.update(data)
      decrypted_final = cipher.final

      File.write(output_path, decrypted + decrypted_final)
    end
  end
end
