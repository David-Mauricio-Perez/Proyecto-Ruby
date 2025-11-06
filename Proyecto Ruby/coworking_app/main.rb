# main.rb
require 'date'
require_relative 'lib/csv_repository'
require_relative 'lib/validadores'
require_relative 'lib/gestor_horarios'
require_relative 'app/models/miembro'
require_relative 'app/models/espacio'
require_relative 'app/models/reserva'
require_relative 'app/controllers/miembro_controller'
require_relative 'app/controllers/espacio_controller'
require_relative 'app/controllers/reserva_controller'
require_relative 'app/views/miembro_view'
require_relative 'app/views/espacio_view'
require_relative 'app/views/reserva_view'
require_relative 'app/views/menu_principal_view'
require_relative 'seed_data'  

class CoworkingApp
  def initialize
    create_data_directory
    
    @miembro_repo = CSVRepository.new('data/miembros.csv', Miembro)
    @espacio_repo = CSVRepository.new('data/espacios.csv', Espacio)
    @reserva_repo = CSVRepository.new('data/reservas.csv', Reserva)
    
    @miembro_controller = MiembroController.new(@miembro_repo)
    @espacio_controller = EspacioController.new(@espacio_repo)
    @reserva_controller = ReservaController.new(@reserva_repo, @miembro_repo, @espacio_repo)
    
    @menu_view = MenuPrincipalView.new
  end

  def ejecutar
    loop do
      @menu_view.mostrar_menu_principal
      opcion = gets.chomp
      
      case opcion
    
      when '9'
        SeedData.cargar
        reiniciar_repositorios
        
      when '1.1'
        @miembro_controller.crear_miembro
      when '1.2'
        @miembro_controller.listar_miembros
      when '1.3'
        @miembro_controller.buscar_miembro
      when '1.4'
        @miembro_controller.actualizar_plan
      when '1.5'
        @miembro_controller.desactivar_miembro
        
      when '2.1'
        @espacio_controller.crear_espacio
      when '2.2'
        @espacio_controller.listar_espacios
      when '2.3'
        @espacio_controller.listar_por_tipo
      when '2.4'
        @espacio_controller.desactivar_espacio
        
      when '3.1'
        @reserva_controller.crear_reserva
      when '3.2'
        @reserva_controller.listar_reservas_miembro
      when '3.3'
        @reserva_controller.listar_reservas_espacio
      when '3.4'
        @reserva_controller.ver_disponibilidad
      when '3.5'
        @reserva_controller.cancelar_reserva
      when '3.6'
        @reserva_controller.generar_reporte
        
      when '0'
        puts "\n¡Gracias por usar el sistema!"
        break
      else
        puts "\n✗ Opción inválida"
      end
      
      puts "\nPresione Enter para continuar..."
      gets
    end
  end

  private

  def create_data_directory
    Dir.mkdir('data') unless Dir.exist?('data')
  end


  def reiniciar_repositorios
    @miembro_repo = CSVRepository.new('data/miembros.csv', Miembro)
    @espacio_repo = CSVRepository.new('data/espacios.csv', Espacio)
    @reserva_repo = CSVRepository.new('data/reservas.csv', Reserva)
    
    @miembro_controller = MiembroController.new(@miembro_repo)
    @espacio_controller = EspacioController.new(@espacio_repo)
    @reserva_controller = ReservaController.new(@reserva_repo, @miembro_repo, @espacio_repo)
  end
end

if __FILE__ == $0
  app = CoworkingApp.new
  app.ejecutar
end