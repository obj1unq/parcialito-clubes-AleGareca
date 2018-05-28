class Club {

	var property equipos = #{}
	var property actividades = #{}
	var focoDeInstitucion = null
	var sociosTotal = 12 //metodo
	var property gastosMensuales = null

	method categoriaDeClub() = focoDeInstitucion

	method sancion() {
		if (sociosTotal < 500) actividades.head().sancionar() else self.actividades({ act => act.sancionar() })
	}

	method reanudar(_unaActividadSocial) {
		_unaActividadSocial.esReanudada()
	}

	method evaluacionDeActividades() = self.actividades({ act => act.obtenerEvaluacion() })

	method evaluacion() = focoDeInstitucion.evaluacionBruta(self) / sociosTotal

	method sociosDestacados() = actividades.map({ act => act.capitan() }) + actividades.map({ act => act.socioOrganizador() })

	method sociosDestacadosEstrellas() = self.sociosDestacados().filter({ socio => socio.esEstrella() })

	method clubPrestigio() = actividades.any({ act => act.equipoExperimentado() }) and self.sociosDestacados().count() >= 5

}

class Profesional {

	var valorConfigurable = 1000

	method condicionParaSerEstrella(unJugador) = unJugador.valorDePase() > valorConfigurable

	method evaluacionBruta(unClub) = unClub.evaluacionDeActividades() * 2 - unClub.gastoMensual() * 5

}

class Comunitario {

	method condicioneParaSerEstrella(unJugador) = unJugador.cantPartidos() > 3

	method evaluacionBruta(unClub) = unClub.evaluacionDeActividades()

}

class Tradicional inherits Profesional {

	method condicionesParaSerEstrella(unJugador) {
		return unJugador.valorDePase() > valorConfigurable or unJugador.cantPartidos() > 3
	}

	override method evaluacionBruta(unClub) = unClub.evaluacionDeActividades() - unClub.gastoMensual()

}

class ActividadDeportivaFutboll inherits ActividadDeportiva {

	override method obtenerEvaluacion() = super() + cantSanciones * 20 - cantSanciones * 30

}

class ActividadDeportiva inherits ActividadSocial {

	var plantel = #{}
	var property capitan = null
	var campeonatos = 0
	var cantSanciones = 0

	override method sancionar() {
		cantSanciones++
	}

	override method obtenerEvaluacion() = if (capitan.esEstrella()) campeonatos * 5 + plantel.count() * 2 + 5 - cantSanciones * 20 else campeonatos * 5 + plantel.count() * 2 - cantSanciones * 20

	method equipoExperimentado() = plantel.all({ jugador => jugador.cantPartidos() >= 10 })

}

class ActividadSocial {

	var property socioOrganizador = null
	var socios = #{}
	var estaSancionado = false
	var evaluacion = 10

	method sancionar() {
		estaSancionado = true
	}

	method esReanudada() {
		estaSancionado = false
	}

	method obtenerEvaluacion() = if (estaSancionado) 0 else evaluacion

}

class Socio {

	var tiempoEnInstitucion = 0
	var property clubPerteneciente = null

	method esEstrella() = tiempoEnInstitucion > 20

}

class Jugador inherits Socio {

	var property valorDePase = 1000
	var property cantPartidos = 0

	override method esEstrella() = clubPerteneciente.categoriaDeClub().condicionParaSerEstrella(self)

}

