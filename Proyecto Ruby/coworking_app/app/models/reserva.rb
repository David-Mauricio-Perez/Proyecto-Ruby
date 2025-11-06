# app/models/reserva.rb
require 'date'
require 'time'

class Reserva
  attr_accessor :id, :miembro_id, :espacio_id, :fecha, :hora_inicio, 
                :hora_fin, :estado, :fecha_creacion, :notas

  ESTADOS = ['confirmada', 'cancelada', 'completada'].freeze

  def initialize(id, miembro_id, espacio_id, fecha, hora_inicio, hora_fin, notas = "")
    @id = id
    @miembro_id = miembro_id
    @espacio_id = espacio_id
    @fecha = fecha.is_a?(String) ? fecha : fecha.strftime('%Y-%m-%d')
    @hora_inicio = hora_inicio
    @hora_fin = hora_fin
    @estado = 'confirmada'
    @fecha_creacion = Time.now
    @notas = notas
  end

  def self.from_csv(row)
    reserva = new(
      row['id'].to_i,
      row['miembro_id'].to_i,
      row['espacio_id'].to_i,
      row['fecha'],
      row['hora_inicio'],
      row['hora_fin'],
      row['notas'] || ""
    )
    reserva.estado = row['estado'] || 'confirmada'
    reserva.fecha_creacion = Time.parse(row['fecha_creacion']) rescue Time.now
    reserva
  end

  # ⭐ MÉTODO CRÍTICO para guardar
  def to_csv_array
    [
      id,
      miembro_id,
      espacio_id,
      fecha,
      hora_inicio,
      hora_fin,
      estado,
      fecha_creacion.strftime('%Y-%m-%d %H:%M:%S'),
      notas
    ]
  end

  def duracion_horas
    inicio = Time.parse("#{fecha} #{hora_inicio}")
    fin = Time.parse("#{fecha} #{hora_fin}")
    ((fin - inicio) / 3600).round(2)
  end

  def activa?
    estado == 'confirmada'
  end

  def cancelar
    @estado = 'cancelada'
  end

  def completar
    @estado = 'completada'
  end

  def to_s
    "Reserva ##{id}: Miembro #{miembro_id} - Espacio #{espacio_id} - " \
    "#{fecha} de #{hora_inicio} a #{hora_fin} (#{estado})"
  end
end