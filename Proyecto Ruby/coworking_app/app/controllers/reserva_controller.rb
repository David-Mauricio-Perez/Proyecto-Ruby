# app/controllers/reserva_controller.rb
class ReservaController
  def initialize(reserva_repo, miembro_repo, espacio_repo)
    @reserva_repo = reserva_repo
    @miembro_repo = miembro_repo
    @espacio_repo = espacio_repo
    @view = ReservaView.new
  end

  def crear_reserva
    datos = @view.obtener_datos_nueva_reserva
    return unless datos
    
    miembro = @miembro_repo.find_by_id(datos[:miembro_id])
    espacio = @espacio_repo.find_by_id(datos[:espacio_id])

    # Validaciones
    unless miembro&.activo?
      @view.mostrar_error("Miembro no válido o inactivo")
      return
    end

    unless espacio&.disponible?
      @view.mostrar_error("Espacio no disponible")
      return
    end

    unless ValidadorReserva.valido?(datos[:fecha], datos[:hora_inicio], 
                                     datos[:hora_fin], datos[:miembro_id])
      @view.mostrar_error("Datos de reserva inválidos")
      return
    end

    # Verificar conflictos
    if GestorHorarios.hay_conflicto?(@reserva_repo.all, datos[:espacio_id], 
                                      datos[:fecha], datos[:hora_inicio], datos[:hora_fin])
      @view.mostrar_error("El espacio está ocupado en ese horario")
      
      espacios_alt = GestorHorarios.espacios_disponibles(
        @espacio_repo.all, 
        @reserva_repo.all,
        datos[:fecha], 
        datos[:hora_inicio], 
        datos[:hora_fin]
      )
      @view.mostrar_alternativas(espacios_alt) if espacios_alt.any?
      return
    end

    # Crear reserva
    id = @reserva_repo.next_id
    reserva = Reserva.new(
      id,
      datos[:miembro_id],
      datos[:espacio_id],
      datos[:fecha],
      datos[:hora_inicio],
      datos[:hora_fin],
      datos[:notas]
    )

    @reserva_repo.add(reserva)
    
    # Calcular costo con descuento
    duracion = reserva.duracion_horas
    descuento = miembro.descuento
    precio_base = espacio.precio_hora * duracion
    costo_final = espacio.calcular_precio(duracion, descuento)
    ahorro = precio_base - costo_final
    
    mensaje = <<~MENSAJE
      ✓ Reserva ##{reserva.id} creada exitosamente
      
      📋 Detalles:
        • Miembro: #{miembro.nombre} (#{miembro.plan})
        • Espacio: #{espacio.nombre}
        • Fecha: #{reserva.fecha}
        • Horario: #{reserva.hora_inicio} - #{reserva.hora_fin}
        • Duración: #{duracion} hora(s)
      
      💰 Resumen de costos:
        • Precio base: $#{precio_base.round(2)}
        • Descuento (#{(descuento * 100).to_i}%): -$#{ahorro.round(2)}
        • TOTAL A PAGAR: $#{costo_final.round(2)}
    MENSAJE
    
    @view.mostrar_exito(mensaje)
  end

  def listar_reservas_miembro
    miembro_id = @view.obtener_miembro_id.to_i
    return @view.mostrar_error("ID inválido") if miembro_id <= 0
    
    miembro = @miembro_repo.find_by_id(miembro_id)
    return @view.mostrar_error("Miembro no encontrado") unless miembro
    
    reservas = @reserva_repo.find_all_by(:miembro_id, miembro_id).select(&:activa?)
    
    if reservas.any?
      @view.mostrar_lista_reservas(reservas, miembro)
    else
      @view.mostrar_error("No hay reservas activas para #{miembro.nombre}")
    end
  end

  def listar_reservas_espacio
    espacio_id = @view.obtener_espacio_id.to_i
    return @view.mostrar_error("ID inválido") if espacio_id <= 0
    
    espacio = @espacio_repo.find_by_id(espacio_id)
    return @view.mostrar_error("Espacio no encontrado") unless espacio
    
    reservas = @reserva_repo.find_all_by(:espacio_id, espacio_id).select(&:activa?)
    
    if reservas.any?
      @view.mostrar_lista_reservas(reservas, nil, espacio)
    else
      @view.mostrar_error("No hay reservas para #{espacio.nombre}")
    end
  end

  def ver_disponibilidad
    datos = @view.obtener_disponibilidad_params
    return unless datos
    
    espacios_disponibles = GestorHorarios.espacios_disponibles(
      @espacio_repo.all,
      @reserva_repo.all,
      datos[:fecha],
      datos[:hora_inicio],
      datos[:hora_fin]
    )

    if espacios_disponibles.any?
      @view.mostrar_lista_espacios(espacios_disponibles)
    else
      @view.mostrar_error("No hay espacios disponibles en ese horario")
    end
  end

  def cancelar_reserva
    id = @view.obtener_id.to_i
    return @view.mostrar_error("ID inválido") if id <= 0
    
    reserva = @reserva_repo.find_by_id(id)
    return @view.mostrar_error("Reserva no encontrada") unless reserva
    
    unless reserva.activa?
      return @view.mostrar_error("La reserva ya está #{reserva.estado}")
    end
    
    if @view.confirmar_cancelacion(reserva)
      if @reserva_repo.update(id, estado: 'cancelada')
        @view.mostrar_exito("Reserva ##{id} cancelada exitosamente")
      else
        @view.mostrar_error("No se pudo cancelar la reserva")
      end
    else
      @view.mostrar_info("Cancelación abortada")
    end
  end

  def generar_reporte
    fecha = @view.obtener_fecha
    return unless fecha
    
    begin
      fecha_obj = Date.parse(fecha)
    rescue ArgumentError
      return @view.mostrar_error("Fecha inválida. Use formato YYYY-MM-DD")
    end
    
    reservas_dia = GestorHorarios.reservas_del_dia(@reserva_repo.all, fecha)
    
    if reservas_dia.any?
      miembros = @miembro_repo.all
      espacios = @espacio_repo.all
      @view.mostrar_reporte_dia(fecha, reservas_dia, miembros, espacios)
    else
      @view.mostrar_error("No hay reservas para #{fecha}")
    end
  end
end