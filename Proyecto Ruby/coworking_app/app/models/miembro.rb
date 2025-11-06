# app/models/miembro.rb
class Miembro
  attr_accessor :id, :nombre, :email, :telefono, :plan, :fecha_registro, :activo

  PLANES = {
    'basico' => { nombre: 'Básico', descuento: 0 },
    'profesional' => { nombre: 'Profesional', descuento: 0.10 },
    'premium' => { nombre: 'Premium', descuento: 0.20 }
  }.freeze

  def initialize(id, nombre, email, telefono, plan = 'basico')
    @id = id
    @nombre = nombre
    @email = email
    @telefono = telefono
    @plan = PLANES.key?(plan) ? plan : 'basico'
    @fecha_registro = Time.now
    @activo = true
  end

  def self.from_csv(row)
    miembro = new(
      row['id'].to_i,
      row['nombre'],
      row['email'],
      row['telefono'],
      row['plan'] || 'basico'
    )
    miembro.fecha_registro = Time.parse(row['fecha_registro']) rescue Time.now
    miembro.activo = row['activo'] == 'true'
    miembro
  end

  # ⭐ ESTE MÉTODO ES CRÍTICO - Sin él no se puede guardar
  def to_csv_array
    [
      id,
      nombre,
      email,
      telefono,
      plan,
      fecha_registro.strftime('%Y-%m-%d %H:%M:%S'),
      activo
    ]
  end

  def descuento
    PLANES[plan][:descuento]
  end

  def premium?
    plan == 'premium'
  end

  def profesional?
    plan == 'profesional'
  end

  def to_s
    "#{id}. #{nombre} (#{email}) - Plan: #{PLANES[plan][:nombre]}"
  end
  def activo?
    activo
  end

  def descuento
    PLANES[plan][:descuento]
  end

  def premium?
    plan == 'premium'
  end

  def profesional?
    plan == 'profesional'
  end

  def to_s
    "#{id}. #{nombre} (#{email}) - Plan: #{PLANES[plan][:nombre]}"
  end
end