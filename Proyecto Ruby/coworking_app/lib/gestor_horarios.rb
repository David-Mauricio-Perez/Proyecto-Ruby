# lib/gestor_horarios.rb
class GestorHorarios
  def self.hay_conflicto?(reservas, espacio_id, fecha, hora_inicio, hora_fin)
    reservas_espacio = reservas.select do |r|
      r.espacio_id == espacio_id && 
      r.fecha == fecha && 
      r.activa?
    end

    inicio_nueva = Time.parse(hora_inicio)
    fin_nueva = Time.parse(hora_fin)

    reservas_espacio.any? do |reserva|
      inicio_existente = Time.parse(reserva.hora_inicio)
      fin_existente = Time.parse(reserva.hora_fin)
      
      !(fin_nueva <= inicio_existente || inicio_nueva >= fin_existente)
    end
  end

  def self.espacios_disponibles(espacios, reservas, fecha, hora_inicio, hora_fin)
    espacios.select do |espacio|
      espacio.disponible? && 
        !hay_conflicto?(reservas, espacio.id, fecha, hora_inicio, hora_fin)
    end
  end

  def self.reservas_del_dia(reservas, fecha)
    reservas.select { |r| r.fecha == fecha && r.activa? }
  end
end