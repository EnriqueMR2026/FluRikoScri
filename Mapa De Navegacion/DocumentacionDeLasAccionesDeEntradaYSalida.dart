/// ---------------------------------------------------------------------------
/// 🌳 ÁRBOL DE ACCIONES: ESCÁNER QR (ENTRADA Y SALIDA)
/// ---------------------------------------------------------------------------
/// Condición Inicial: El código QR ha sido escaneado y validado exitosamente.
/// ---------------------------------------------------------------------------

// ============================================================================
// 🟢 CAMINO A: REGISTRAR ENTRADA (Cuando turnoIniciadoGuardado == False)
// ============================================================================

1.1 Crear Recibo de Entrada
    Action: Firestore -> Create Document
    Collection: HistorialAsistencias
    Fields:
        - refEmpleado: App State > refEmpleadoGuardada
        - fechaDelRegistro: Global Properties > Current Time
        - horaEntrada: Global Properties > Current Time
        - estadoAsistencia: Custom Function > evaluarEstadoEntrada
    Output Variable: nuevoRegistroAsistencia

1.2 Construir El Puente y Guardar la Verdad
    Action: Firestore -> Update Document
    Reference: App State > refEmpleadoGuardada (Colección: Usuarios)
    Fields:
        - asistenciaActualRef: Action Output > nuevoRegistroAsistencia
        - turnoIniciado: Set Value > True
        - horaEntradaReal: Global Properties > Current Time

1.3 Encender el Motor Local (Calculadora)
    Action: State Management -> Update App State
    Fields:
        - turnoIniciadoGuardado: Set Value > True
        - horaEntradaRealGuardada: Set Value > Global Properties > Current Time

1.4 Despedida Visual
    Action: Alert Dialog -> Informational Dialog
    Title: "¡Bienvenido!"
    Message: "Tu entrada ha sido registrada exitosamente. ¡Que tengas un excelente turno!"


// ============================================================================
// 🔴 CAMINO B: REGISTRAR SALIDA (Cuando turnoIniciadoGuardado == True)
// ============================================================================

2.1 El Guardián (Lectura de Seguridad)
    Action: Firestore -> Read Document
    Reference: App State > refEmpleadoGuardada
    Output Variable: perfilEmpleadoFresco

2.2 Rescate del Tiempo (Lectura del Ticket)
    Action: Firestore -> Read Document
    Reference: Action Output > perfilEmpleadoFresco > asistenciaActualRef
    Output Variable: ticketAsistenciaFresco

2.3 Sellar el Boleto
    Action: Firestore -> Update Document
    Reference: Action Output > perfilEmpleadoFresco > asistenciaActualRef
    Fields:
        - horaSalida: Global Properties > Current Time

2.4 EL CEREBRO DEL CORTE (Condicional Principal)
    Action: Add Conditional Action
    Condition: Custom Function > obtenerDiaLaboral(ticketAsistenciaFresco > horaEntrada) == App State > diaDePagoGuardado

    // ------------------------------------------------------------------------
    // 💸 TRUE: ¡Es Día de Corte! (Cierre de Nómina)
    // ------------------------------------------------------------------------
    2.4.1 Crear el Recibo de Nómina
        Action: Firestore -> Create Document
        Collection: Nominas
        Fields:
            - refEmpleado: App State > refEmpleadoGuardada
            - nombreEmpleado: Action Output > perfilEmpleadoFresco > nombreEmpleado
            - fechaCorte: Action Output > ticketAsistenciaFresco > horaEntrada
            - estadoPago: "Pendiente"
            - sueldoSemanalBase: App State > sueldoSemanalGuardado
            - propinasCobradas: App State > propinasGuardada
            - bonosCobrados: App State > bonosGuardado
            - reposicionCobrada: App State > reposicionGuardada
            - faltasCobradas: App State > faltasGuardadas
            - retardosCobrados: Custom Function > calcularRetardosCobrados
            - totalNetoAPagar: Custom Function > calcularNetoAPagar

    2.4.2 Resetear Contadores en Firebase
        Action: Firestore -> Update Document
        Reference: App State > refEmpleadoGuardada (Colección: Usuarios)
        Fields (Todos a 0):
            - propinas, bonos, reposicion, faltas, diasTrabajadosSemana, retardos, sueldoAcumulado

    2.4.3 Resetear Contadores en el Teléfono
        Action: State Management -> Update App State
        Fields (Todos a 0):
            - sueldoAcumuladoGuardado, faltasGuardadas, bonosGuardados, reposicionGuardada, propinasGuardada, retardosGuardados

    2.4.4 Avisar al Guardia
        Action: Firestore -> Create Document
        Collection: Notificaciones
        Fields:
            - destinatarioRef: App State > refEmpleadoGuardada
            - categoria: "nomina"
            - subcategoria: "Nueva Nomina"

    // ------------------------------------------------------------------------
    // 🛑 FALSE: Día Normal
    // ------------------------------------------------------------------------
    - NADA

2.5 Limpieza Final del Puente
    Action: Firestore -> Update Document
    Reference: App State > refEmpleadoGuardada (Colección: Usuarios)
    Fields:
        - asistenciaActualRef: Delete / Clear Value
        - turnoIniciado: Set Value > False

2.6 Apagar Motor Local
    Action: State Management -> Update App State
    Fields:
        - turnoIniciadoGuardado: Set Value > False

2.7 Despedida Visual
    Action: Alert Dialog -> Informational Dialog
    Title: "¡Turno Finalizado!"
    Message: "Tu salida ha sido registrada. ¡Descansa!"

2.8 Retorno Seguro
    Action: Navigate To
    Page: MenuPrincipal



// Lo mismo de arriba pero lineal el texto y con menos detalles
//  Acciones del boton de Registrar ENTRADA/SALIDA, despues de validar el codigo QR{
//      * camino de ENTRADA {create documento: HistorialAsistencias [refEmpleado, fechaDelRegistro, horaEntrada, estadoAsistencia]; Update Documente: App Satet > refEmpleadoGuardado [asistenciaActualRef, turnoIniciado, horaEntradaReal]; Update App State [turnoIniciadoGuardado, horaEntradaRealGuardada]; Informational Dialog [Bienvenido]} 
//      * camino de SALIDA {Read Document: App Satet > refEmpleadoGuardada [perfilEmpleadoFresco]; Read Document: perfilEmpleadoFresco > asistenciaActualRef [ticketAsistenciaFresco]; Update Document: perfilEmpleadoFresco > asistenciaActualRef [horaSalida]; Condicional: (False {NADA}; TRUE {Create Document: Nomina [refEmpleado, nombreEmpleado, fechaCorte, estadoPago, sueldoSemanalBase, propinasGuardadas, bonosCobrados, reposicionCobrada, faltasCobradas, retardosCobrados, totalNetoAPagar]; Update document: App State > refEmpleadoGuardada [propinas, bonos, reposicion, faltas, diasTrabajados, retardos, sueldoAcumulado (todo a 0)]; Update App State: sueldoAcumuladoGuardado, faltasGuardadas, bonosGuardados, reposicionGuardada, propinasGuardada, retardos,Guardados [Todo a 0]; Create Document: Notificaciones [destinatarioRef, categoria, subcategoria]}); Update Document: App State > refEmpleadoGuardada [asistenciaActualRef, turnoIniciado]; Update App State: turnoIniciadoGuardado [False]; Informational Dialog: Turno Finalizado; Navigate To: MenuPrincipal}
//  }