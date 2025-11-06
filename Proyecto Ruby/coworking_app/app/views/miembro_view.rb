# app/views/miembro_view.rb
class MiembroView
  def obtener_datos_nuevo_miembro
    puts "\n=== REGISTRAR NUEVO MIEMBRO ==="
    
    print "Nombre: "
    nombre = gets.chomp
    
    print "Email: "
    email = gets.chomp
    
    print "Teléfono: "
    telefono = gets.chomp
    
    puts "Planes disponibles: basico, profesional, premium"
    print "Plan: "
    plan = gets.chomp
    
    { nombre: nombre, email: email, telefono: telefono, plan: plan }
  end

  def mostrar_lista_miembros(miembros)
    puts "\n=== LISTA DE MIEMBROS ACTIVOS ==="
    puts "-" * 80
    printf "%-5s | %-20s | %-25s | %-15s | %-10s\n",
           "ID", "Nombre", "Email", "Plan", "Teléfono"
    puts "-" * 80
    
    miembros.each do |m|
      printf "%-5d | %-20s | %-25s | %-15s | %-10s\n",
             m.id, m.nombre, m.email, m.plan, m.telefono
    end
    puts "-" * 80
  end

  def mostrar_detalles_miembro(miembro)
    puts "\n=== DETALLES DEL MIEMBRO ==="
    puts "ID: #{miembro.id}"
    puts "Nombre: #{miembro.nombre}"
    puts "Email: #{miembro.email}"
    puts "Teléfono: #{miembro.telefono}"
    puts "Plan: #{miembro.plan}"
    puts "Registrado: #{miembro.fecha_registro}"
    puts "Activo: #{miembro.activo ? 'Sí' : 'No'}"
  end

  def obtener_id
    print "Ingrese ID del miembro: "
    gets.chomp
  end

  def obtener_plan
    puts "Planes: basico, profesional, premium"
    print "Nuevo plan: "
    gets.chomp
  end

  def mostrar_exito(mensaje)
    puts "\n✓ #{mensaje}"
  end

  def mostrar_error(mensaje)
    puts "\n✗ Error: #{mensaje}"
  end
end