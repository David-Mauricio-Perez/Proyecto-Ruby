# app/controllers/miembro_controller.rb
class MiembroController
  def initialize(miembro_repo)
    @repo = miembro_repo
    @view = MiembroView.new
  end

  def crear_miembro
    datos = @view.obtener_datos_nuevo_miembro
    
    unless ValidadorMiembro.valido?(datos[:nombre], datos[:email], datos[:telefono])
      @view.mostrar_error("Datos inválidos")
      return
    end

    id = @repo.count + 1
    miembro = Miembro.new(
      id,
      datos[:nombre],
      datos[:email],
      datos[:telefono],
      datos[:plan]
    )
    
    @repo.add(miembro)
    @view.mostrar_exito("Miembro #{miembro.nombre} registrado exitosamente")
  end

  def listar_miembros
    miembros = @repo.all.select(&:activo?)
    @view.mostrar_lista_miembros(miembros)
  end

  def buscar_miembro
    id = @view.obtener_id.to_i
    miembro = @repo.find_by_id(id)
    
    if miembro
      @view.mostrar_detalles_miembro(miembro)
    else
      @view.mostrar_error("Miembro no encontrado")
    end
  end

  def actualizar_plan
    id = @view.obtener_id.to_i
    nuevo_plan = @view.obtener_plan
    
    if @repo.update(id, plan: nuevo_plan)
      @view.mostrar_exito("Plan actualizado exitosamente")
    else
      @view.mostrar_error("No se pudo actualizar el plan")
    end
  end

  def desactivar_miembro
    id = @view.obtener_id.to_i
    
    if @repo.update(id, activo: false)
      @view.mostrar_exito("Miembro desactivado")
    else
      @view.mostrar_error("No se pudo desactivar el miembro")
    end
  end
end