# seed_data.rb
require_relative 'lib/csv_repository'
require_relative 'app/models/miembro'
require_relative 'app/models/espacio'
require_relative 'app/models/reserva'

class SeedData
  def self.cargar
    puts "\n🌱 Cargando datos de prueba..."
    
    # Limpiar datos anteriores
    limpiar_datos
    
    # Crear repositorios
    miembro_repo = CSVRepository.new('data/miembros.csv', Miembro)
    espacio_repo = CSVRepository.new('data/espacios.csv', Espacio)
    reserva_repo = CSVRepository.new('data/reservas.csv', Reserva)
    
    # Cargar datos
    cargar_miembros(miembro_repo)
    cargar_espacios(espacio_repo)
    cargar_reservas(reserva_repo)
    
    puts "\n✅ Datos de prueba cargados exitosamente!"
    puts "\n📊 Resumen:"
    puts "   • #{miembro_repo.count} miembros"
    puts "   • #{espacio_repo.count} espacios"
    puts "   • #{reserva_repo.count} reservas"
    puts "\n"
  end
  
  private
  
  def self.limpiar_datos
    ['data/miembros.csv', 'data/espacios.csv', 'data/reservas.csv'].each do |file|
      File.delete(file) if File.exist?(file)
    end
  end
  
  def self.cargar_miembros(repo)
    puts "   → Creando miembros..."
    
    miembros = [
      { nombre: 'Ana García', email: 'ana.garcia@gmail.com', telefono: '3001234567', plan: 'premium' },
      { nombre: 'Carlos López', email: 'carlos.lopez@outlook.com', telefono: '3109876543', plan: 'profesional' },
      { nombre: 'María Rodríguez', email: 'maria.rodriguez@hotmail.com', telefono: '3205551234', plan: 'basico' },
      { nombre: 'Juan Martínez', email: 'juan.martinez@empresa.com', telefono: '3157778888', plan: 'premium' },
      { nombre: 'Laura Sánchez', email: 'laura.sanchez@correo.co', telefono: '3183334444', plan: 'profesional' },
      { nombre: 'Pedro Gómez', email: 'pedro.gomez@mail.com', telefono: '3009991111', plan: 'basico' }
    ]
    
    miembros.each_with_index do |datos, index|
      miembro = Miembro.new(
        index + 1,
        datos[:nombre],
        datos[:email],
        datos[:telefono],
        datos[:plan]
      )
      repo.add(miembro)
    end
    
    puts "      ✓ #{repo.count} miembros creados"
  end
  
  def self.cargar_espacios(repo)
    puts "   → Creando espacios..."
    
    espacios = [
      { nombre: 'Escritorio Individual A1', tipo: 'escritorio', capacidad: 1, precio: 5000, desc: 'Escritorio con vista a la ciudad' },
      { nombre: 'Escritorio Individual B2', tipo: 'escritorio', capacidad: 1, precio: 4500, desc: 'Escritorio en zona tranquila' },
      { nombre: 'Sala de Reuniones Innovación', tipo: 'sala_reunion', capacidad: 8, precio: 25000, desc: 'Sala con TV 4K y pizarra digital' },
      { nombre: 'Sala de Reuniones Colaboración', tipo: 'sala_reunion', capacidad: 6, precio: 20000, desc: 'Sala equipada para videoconferencias' },
      { nombre: 'Oficina Privada Premium', tipo: 'privada', capacidad: 4, precio: 35000, desc: 'Oficina privada con baño propio' },
      { nombre: 'Oficina Privada Estándar', tipo: 'privada', capacidad: 2, precio: 28000, desc: 'Oficina privada con escritorios dobles' },
      { nombre: 'Salón de Eventos Principal', tipo: 'evento', capacidad: 50, precio: 80000, desc: 'Salón con escenario y sistema de audio' },
      { nombre: 'Sala Coworking Abierta', tipo: 'escritorio', capacidad: 15, precio: 3000, desc: 'Espacio compartido con mesas amplias' }
    ]
    
    espacios.each_with_index do |datos, index|
      espacio = Espacio.new(
        index + 1,
        datos[:nombre],
        datos[:tipo],
        datos[:capacidad],
        datos[:precio],
        datos[:desc]
      )
      repo.add(espacio)
    end
    
    puts "      ✓ #{repo.count} espacios creados"
  end
  
  def self.cargar_reservas(repo)
    puts "   → Creando reservas..."
    
    hoy = Date.today
    manana = hoy + 1
    pasado = hoy + 2
    
    reservas = [
      # Reservas de hoy
      { miembro_id: 1, espacio_id: 5, fecha: hoy.to_s, inicio: '09:00', fin: '12:00', notas: 'Reunión con clientes importantes' },
      { miembro_id: 2, espacio_id: 1, fecha: hoy.to_s, inicio: '08:00', fin: '17:00', notas: 'Jornada completa de trabajo' },
      { miembro_id: 3, espacio_id: 3, fecha: hoy.to_s, inicio: '14:00', fin: '16:00', notas: 'Presentación de proyecto' },
      { miembro_id: 4, espacio_id: 2, fecha: hoy.to_s, inicio: '10:00', fin: '13:00', notas: 'Desarrollo de software' },
      
      # Reservas de mañana
      { miembro_id: 1, espacio_id: 7, fecha: manana.to_s, inicio: '15:00', fin: '18:00', notas: 'Workshop de innovación' },
      { miembro_id: 5, espacio_id: 4, fecha: manana.to_s, inicio: '09:00', fin: '11:00', notas: 'Reunión de equipo' },
      { miembro_id: 2, espacio_id: 6, fecha: manana.to_s, inicio: '08:00', fin: '12:00', notas: 'Sesión de diseño' },
      { miembro_id: 6, espacio_id: 8, fecha: manana.to_s, inicio: '13:00', fin: '17:00', notas: 'Trabajo remoto' },
      { miembro_id: 3, espacio_id: 3, fecha: manana.to_s, inicio: '10:00', fin: '12:00', notas: 'Reunión con inversionistas' },
      
      # Reservas de pasado mañana
      { miembro_id: 4, espacio_id: 5, fecha: pasado.to_s, inicio: '09:00', fin: '17:00', notas: 'Día completo de consultoría' },
      { miembro_id: 1, espacio_id: 1, fecha: pasado.to_s, inicio: '08:00', fin: '10:00', notas: 'Concentración individual' },
      { miembro_id: 5, espacio_id: 7, fecha: pasado.to_s, inicio: '16:00', fin: '20:00', notas: 'Evento de networking' }
    ]
    
    reservas.each_with_index do |datos, index|
      reserva = Reserva.new(
        index + 1,
        datos[:miembro_id],
        datos[:espacio_id],
        datos[:fecha],
        datos[:inicio],
        datos[:fin],
        datos[:notas]
      )
      repo.add(reserva)
    end
    
    puts "      ✓ #{repo.count} reservas creadas"
  end
end

# Ejecutar si se llama directamente
if __FILE__ == $0
  SeedData.cargar
end