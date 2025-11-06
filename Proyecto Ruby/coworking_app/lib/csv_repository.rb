# lib/csv_repository.rb
require 'csv'
require 'fileutils'
require_relative 'repository'

class CSVRepository < Repository
  def initialize(file_path, model_class)
    super() # Ahora Repository.initialize no espera argumentos
    @file_path = file_path
    @model_class = model_class
    ensure_file_exists
    load_data
  end

  private

  def ensure_file_exists
    return if File.exist?(@file_path)
    
    FileUtils.mkdir_p(File.dirname(@file_path))
    File.write(@file_path, headers.join(',') + "\n")
  end

  def headers
    case @model_class.name
    when 'Miembro'
      %w[id nombre email telefono plan fecha_registro activo]
    when 'Espacio'
      %w[id nombre tipo capacidad precio_hora descripcion activo]
    when 'Reserva'
      %w[id miembro_id espacio_id fecha hora_inicio hora_fin estado fecha_creacion notas]
    else
      []
    end
  end

  def load_data
    return unless File.exist?(@file_path)

    begin
      CSV.foreach(@file_path, headers: true) do |row|
        next if row.to_h.values.all?(&:nil?) # Salta líneas vacías
        @data << @model_class.from_csv(row)
      end
    rescue CSV::MalformedCSVError => e
      puts "⚠️  Advertencia: Error leyendo #{@file_path}: #{e.message}"
      @data = []
    rescue => e
      puts "⚠️  Error cargando #{@file_path}: #{e.message}"
      @data = []
    end
  end

  def save
    begin
      CSV.open(@file_path, 'w') do |csv|
        # Escribir encabezados
        csv << headers
        
        # Escribir datos
        @data.each do |item|
          csv << item.to_csv_array
        end
      end
      true
    rescue => e
      puts "❌ Error guardando datos en #{@file_path}: #{e.message}"
      false
    end
  end
end