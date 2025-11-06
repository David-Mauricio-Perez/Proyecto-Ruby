# app/views/reserva_view.rb
class ReservaView
  def obtener_datos_nueva_reserva
    puts "\n=== CREAR NUEVA RESERVA ==="
    
    print "ID del miembro: "
    miembro_id = gets.chomp.to_i
    
    print "ID del espacio: "
    espacio_id = gets.chomp.to_i
    
    print "Fecha (YYYY-MM-DD): "
    fecha = gets.chomp
    
    print "Hora inicio (HH:MM): "
    hora_inicio = gets.chomp
    
    print "Hora fin (HH:MM): "
    hora_fin = gets.chomp
    
    print "Notas (opcional): "
    notas = gets.chomp
    
    {
      miembro_id: miembro_id,
      espacio_id: espacio_id,
      fecha: fecha,
      hora_inicio: hora_inicio,
      hora_fin: hora_fin,
      notas: notas
    }
  end

  #  Acepta parámetros opcionales
  def mostrar_lista_reservas(reservas, miembro = nil, espacio = nil)
    titulo = if miembro
      "RESERVAS DE #{miembro.nombre.upcase}"
    elsif espacio
      "RESERVAS EN #{espacio.nombre.upcase}"
    else
      "LISTA DE RESERVAS"
    end
    
    puts "\n=== #{titulo} ==="
    puts "-" * 100
    printf "%-5s | %-10s | %-10s | %-12s | %-12s | %-12s | %-15s\n",
           "ID", "Miembro", "Espacio", "Fecha", "Inicio", "Fin", "Estado"
    puts "-" * 100
    
    reservas.each do |r|
      printf "%-5d | %-10d | %-10d | %-12s | %-12s | %-12s | %-15s\n",
             r.id, r.miembro_id, r.espacio_id, r.fecha, 
             r.hora_inicio, r.hora_fin, r.estado
    end
    puts "-" * 100
    puts "\nTotal: #{reservas.count} reserva(s)"
  end

  def mostrar_alternativas(espacios)
    if espacios.any?
      puts "\n💡 Espacios alternativos disponibles:"
      espacios.each do |e|
        puts "   • #{e.nombre} - $#{e.precio_hora}/hora (Cap: #{e.capacidad})"
      end
    end
  end

  def obtener_disponibilidad_params
    print "Fecha (YYYY-MM-DD): "
    fecha = gets.chomp
    
    print "Hora inicio (HH:MM): "
    hora_inicio = gets.chomp
    
    print "Hora fin (HH:MM): "
    hora_fin = gets.chomp
    
    { fecha: fecha, hora_inicio: hora_inicio, hora_fin: hora_fin }
  end

  def obtener_miembro_id
    print "Ingrese ID del miembro: "
    gets.chomp
  end

  def obtener_espacio_id
    print "Ingrese ID del espacio: "
    gets.chomp
  end

  def obtener_id
    print "Ingrese ID de la reserva: "
    gets.chomp
  end

  def obtener_fecha
    print "Ingrese fecha (YYYY-MM-DD): "
    gets.chomp
  end

  def mostrar_reporte_dia(fecha, reservas, miembros = nil, espacios = nil)
    puts "\n" + "=" * 100
    puts "  REPORTE DE RESERVAS - #{fecha}".center(100)
    puts "=" * 100
    
    if reservas.empty?
      puts "\nNo hay reservas para este día"
      return
    end
    
    puts "\n%-5s | %-15s | %-15s | %-12s | %-12s | %-10s" % 
         ["ID", "Miembro", "Espacio", "Inicio", "Fin", "Estado"]
    puts "-" * 100
    
    total_horas = 0
    
    reservas.each do |r|
      miembro_nombre = miembros ? 
        (miembros.find { |m| m.id == r.miembro_id }&.nombre || "Desconocido") : 
        r.miembro_id.to_s
      
      espacio_nombre = espacios ? 
        (espacios.find { |e| e.id == r.espacio_id }&.nombre || "Desconocido") : 
        r.espacio_id.to_s
      
      printf "%-5d | %-15s | %-15s | %-12s | %-12s | %-10s\n",
             r.id, 
             miembro_nombre[0..14], 
             espacio_nombre[0..14], 
             r.hora_inicio, 
             r.hora_fin, 
             r.estado
      
      total_horas += r.duracion_horas if r.activa?
    end
    
    puts "-" * 100
    puts "\n📊 Resumen:"
    puts "   • Total de reservas: #{reservas.count}"
    puts "   • Reservas activas: #{reservas.count(&:activa?)}"
    puts "   • Total de horas reservadas: #{total_horas.round(2)} hrs"
    puts "=" * 100
  end

  def mostrar_lista_espacios(espacios)
    puts "\n=== ESPACIOS DISPONIBLES ==="
    puts "-" * 90
    printf "%-5s | %-20s | %-15s | %-12s | %-10s\n",
           "ID", "Nombre", "Tipo", "Capacidad", "Precio/hr"
    puts "-" * 90
    
    espacios.each do |e|
      printf "%-5d | %-20s | %-15s | %-12d | $%-9.2f\n",
             e.id, e.nombre, e.tipo, e.capacidad, e.precio_hora
    end
    puts "-" * 90
    puts "\nTotal: #{espacios.count} espacio(s) disponible(s)"
  end

  def mostrar_exito(mensaje)
    puts "\n✓ #{mensaje}"
  end

  def mostrar_error(mensaje)
    puts "\n✗ Error: #{mensaje}"
  end

  def mostrar_info(mensaje)
    puts "\nℹ️  #{mensaje}"
  end

  def confirmar_cancelacion(reserva)
    puts "\n⚠️  ¿Está seguro de cancelar esta reserva?"
    puts "    #{reserva}"
    print "Confirmar (s/n): "
    respuesta = gets.chomp.downcase
    respuesta == 's' || respuesta == 'si' || respuesta == 'sí'
  end
end