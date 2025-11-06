# app/views/espacio_view.rb
class EspacioView
  def obtener_datos_nuevo_espacio
    puts "\n=== REGISTRAR NUEVO ESPACIO ==="
    
    print "Nombre del espacio: "
    nombre = gets.chomp
    
    puts "Tipos: escritorio, sala_reunion, privada, evento"
    print "Tipo: "
    tipo = gets.chomp
    
    print "Capacidad (personas): "
    capacidad = gets.chomp.to_i
    
    print "Precio por hora ($): "
    precio_hora = gets.chomp.to_f
    
    print "Descripción (opcional): "
    descripcion = gets.chomp
    
    {
      nombre: nombre,
      tipo: tipo,
      capacidad: capacidad,
      precio_hora: precio_hora,
      descripcion: descripcion
    }
  end

  def mostrar_lista_espacios(espacios)
    puts "\n=== LISTA DE ESPACIOS DISPONIBLES ==="
    puts "-" * 90
    printf "%-5s | %-20s | %-15s | %-12s | %-10s\n",
           "ID", "Nombre", "Tipo", "Capacidad", "Precio/hr"
    puts "-" * 90
    
    espacios.each do |e|
      printf "%-5d | %-20s | %-15s | %-12d | $%-9.2f\n",
             e.id, e.nombre, e.tipo, e.capacidad, e.precio_hora
    end
    puts "-" * 90
  end

  def obtener_tipo_espacio
    puts "Tipos: escritorio, sala_reunion, privada, evento"
    print "Seleccione tipo: "
    gets.chomp
  end

  def obtener_id
    print "Ingrese ID del espacio: "
    gets.chomp
  end

  def mostrar_exito(mensaje)
    puts "\n✓ #{mensaje}"
  end

  def mostrar_error(mensaje)
    puts "\n✗ Error: #{mensaje}"
  end
end