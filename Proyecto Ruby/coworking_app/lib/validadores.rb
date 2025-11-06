# lib/validadores.rb
module Validadores
  class ValidadorMiembro
    EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    def self.valido?(nombre, email, telefono)
      errores = []
      errores << "Nombre muy corto" unless nombre_valido?(nombre)
      errores << "Email inválido" unless email_valido?(email)
      errores << "Teléfono inválido" unless telefono_valido?(telefono)
      
      if errores.any?
        puts "Errores de validación:"
        errores.each { |e| puts "  - #{e}" }
        return false
      end
      true
    end

    private

    def self.nombre_valido?(nombre)
      nombre && nombre.strip.length >= 3
    end

    def self.email_valido?(email)
      email && email.match?(EMAIL_REGEX)
    end

    def self.telefono_valido?(telefono)
      telefono && telefono.strip.length >= 7
    end
  end

  class ValidadorReserva
    def self.valido?(fecha, hora_inicio, hora_fin, miembro_id)
      errores = []
      errores << "Fecha inválida o pasada" unless fecha_valida?(fecha)
      errores << "Horarios inválidos" unless horarios_validos?(hora_inicio, hora_fin)
      errores << "Miembro ID inválido" unless miembro_id.to_i > 0
      
      if errores.any?
        puts "Errores de validación:"
        errores.each { |e| puts "  - #{e}" }
        return false
      end
      true
    end

    private

    def self.fecha_valida?(fecha)
      Date.parse(fecha) >= Date.today
    rescue ArgumentError
      false
    end

    def self.horarios_validos?(hora_inicio, hora_fin)
      inicio = Time.parse(hora_inicio)
      fin = Time.parse(hora_fin)
      fin > inicio && (fin - inicio) >= 3600 # Mínimo 1 hora
    rescue ArgumentError
      false
    end
  end

  class ValidadorEspacio
    def self.valido?(nombre, tipo, capacidad, precio)
      errores = []
      errores << "Nombre vacío" if nombre.to_s.strip.empty?
      errores << "Tipo inválido" unless Espacio::TIPOS.key?(tipo)
      errores << "Capacidad debe ser > 0" unless capacidad.to_i > 0
      errores << "Precio debe ser >= 0" unless precio.to_f >= 0
      
      if errores.any?
        puts "Errores de validación:"
        errores.each { |e| puts "  - #{e}" }
        return false
      end
      true
    end
  end
end

# Para mantener compatibilidad
ValidadorMiembro = Validadores::ValidadorMiembro
ValidadorReserva = Validadores::ValidadorReserva
ValidadorEspacio = Validadores::ValidadorEspacio