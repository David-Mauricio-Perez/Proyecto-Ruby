# app/views/menu_principal_view.rb
class MenuPrincipalView
  def mostrar_menu_principal
    puts "\n" + "=" * 60
    puts "   SISTEMA DE GESTIÓN DE RESERVAS - COWORKING"
    puts "=" * 60
    puts "\n[1] GESTIÓN DE MIEMBROS"
    puts "    1.1 - Registrar nuevo miembro"
    puts "    1.2 - Listar miembros"
    puts "    1.3 - Ver detalles de miembro"
    puts "    1.4 - Actualizar plan"
    puts "    1.5 - Desactivar miembro"
    
    puts "\n[2] GESTIÓN DE ESPACIOS"
    puts "    2.1 - Crear nuevo espacio"
    puts "    2.2 - Listar todos los espacios"
    puts "    2.3 - Listar espacios por tipo"
    puts "    2.4 - Desactivar espacio"
    
    puts "\n[3] GESTIÓN DE RESERVAS"
    puts "    3.1 - Crear nueva reserva"
    puts "    3.2 - Ver reservas de miembro"
    puts "    3.3 - Ver reservas de espacio"
    puts "    3.4 - Verificar disponibilidad"
    puts "    3.5 - Cancelar reserva"
    puts "    3.6 - Ver reporte del día"
    
    puts "\n" + "-" * 60
    puts "[9] 🌱 Cargar datos de prueba"  # ⭐ 
    puts "[0] Salir"
    puts "=" * 60
    print "\nSeleccione opción: "
  end

  def limpiar_pantalla
    system('clear') || system('cls')
  end
end