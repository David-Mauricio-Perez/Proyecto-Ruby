# app/controllers/espacio_controller.rb
class EspacioController
  def initialize(espacio_repo)
    @repo = espacio_repo
    @view = EspacioView.new
  end

  def crear_espacio
    datos = @view.obtener_datos_nuevo_espacio
    
    unless ValidadorEspacio.valido?(datos[:nombre], datos[:tipo], 
                                     datos[:capacidad], datos[:precio_hora])
      @view.mostrar_error("Datos inválidos")
      return
    end

    id = @repo.count + 1
    espacio = Espacio.new(
      id,
      datos[:nombre],
      datos[:tipo],
      datos[:capacidad],
      datos[:precio_hora],
      datos[:descripcion]
    )
    
    @repo.add(espacio)
    @view.mostrar_exito("Espacio #{espacio.nombre} creado exitosamente")
  end

  def listar_espacios
    espacios = @repo.all.select(&:disponible?)
    @view.mostrar_lista_espacios(espacios)
  end

  def listar_por_tipo
    tipo = @view.obtener_tipo_espacio
    espacios = @repo.find_all_by(:tipo, tipo).select(&:disponible?)
    
    if espacios.any?
      @view.mostrar_lista_espacios(espacios)
    else
      @view.mostrar_error("No hay espacios de ese tipo disponibles")
    end
  end

  def desactivar_espacio
    id = @view.obtener_id.to_i
    
    if @repo.update(id, activo: false)
      @view.mostrar_exito("Espacio desactivado")
    else
      @view.mostrar_error("No se pudo desactivar el espacio")
    end
  end
end