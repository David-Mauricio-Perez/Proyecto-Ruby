# app/models/espacio.rb
class Espacio
  attr_accessor :id, :nombre, :tipo, :capacidad, :precio_hora, :activo, :descripcion

  TIPOS = {
    'escritorio' => 'Escritorio Individual',
    'sala_reunion' => 'Sala de Reunión',
    'privada' => 'Oficina Privada',
    'evento' => 'Espacio para Eventos'
  }.freeze

  def initialize(id, nombre, tipo, capacidad, precio_hora, descripcion = "")
    @id = id
    @nombre = nombre
    @tipo = validar_tipo(tipo)
    @capacidad = capacidad
    @precio_hora = precio_hora.to_f
    @descripcion = descripcion
    @activo = true
  end

  def self.from_csv(row)
    espacio = new(
      row['id'].to_i,
      row['nombre'],
      row['tipo'],
      row['capacidad'].to_i,
      row['precio_hora'].to_f,
      row['descripcion'] || ""
    )
    espacio.activo = row['activo'] == 'true'
    espacio
  end

  # ⭐ MÉTODO CRÍTICO para guardar
  def to_csv_array
    [
      id,
      nombre,
      tipo,
      capacidad,
      precio_hora,
      descripcion,
      activo
    ]
  end

  def disponible?
    activo
  end

    def activo?
    activo
  end

  def calcular_precio(horas, descuento = 0)
    subtotal = precio_hora * horas
    subtotal * (1 - descuento)
  end

  def to_s
    "#{id}. #{nombre} (#{TIPOS[tipo]}) - Cap: #{capacidad} - $#{precio_hora}/hr"
  end

  private

  def validar_tipo(tipo)
    TIPOS.key?(tipo) ? tipo : 'escritorio'
  end
end