// Aplicacion en Flutterflow en Construccion...
Riko App {

    InicioSesion { // Ya construido
        AutenticacionCasera {
            NO usa el Firebase Auth oficial. Hace una consulta directa a la colección 'Usuarios' validando que coincida el 'numeroEmpleado' y la 'contrasena'.
        }
        ValidacionPrimerIngreso {
            Lee el campo 'requiereCambioContrasena' del usuario.
            Si es TRUE: Abre componente para cambiar contraseña (pide nueva contraseña 2 veces para confirmar). Guarda la nueva en Firebase, actualiza el campo a FALSE y da acceso.
            Si es FALSE: Avanza directamente al MenuPrincipal.
        }
        VariablesAppStatePersistidas {
            Al iniciar sesión exitosamente, guarda en el dispositivo (App State Persistido) los datos clave para ahorrar lecturas en toda la app:
            - refEmpleado (Doc Reference): Para crear/editar documentos con 0 lecturas.
            - numeroEmpleado (Integer): Para imprimir tickets y mostrar en perfil.
            - puesto (String): Para validar visibilidad de pantallas.
            - horaEntradaGuardada y horaSalidaGuardada (Strings): Para alimentar la calculadora de nómina al instante.
        }
    }

    MenuPrincipal { // Tiene 5 Botones verticalmente |  Ya construido
        
        // Condicion de Visibilidad o Acceso: "Encargada", "Mesera", "Cocinero"
        Nomina { // Ya construido | "Logica de Funcionalidad al tocarlo: #15"
            Visual {
                Formato limpio de "Recibo Semanal" (Encabezado, Percepciones, Deducciones, Total Neto a Pagar), sin códigos oficiales.
            }
            Variables {
                Lee App State: numeroEmpleado, turnoIniciado, sueldoSemanal, horaEntrada, horaSalida, diaDePago, diaDeDescanso.
            }
            CalculadoraEnTiempoReal {
                Muestra el sueldo acumulado sumando centavos segundo a segundo (Ej. $ 48.2964 MXN).
                Motor Híbrido: Utiliza un Loop en OnPageLoad con un Delay dinámico conectado al 'MenuVelocidad' (Slider 1% - 100% convertido a milisegundos).
                Bloqueo por Falta: Si App State (turnoIniciado) es False, el Loop se rompe y la calculadora se congela.
                Ajuste Medianoche: La matemática reconoce si el turno cruza de PM a AM para no reiniciar el cronómetro.
            }
            NominaAnterior VER {
                ContenedorPadre: Hace un Query Collection a 'Nominas' (List of Documents, Limit 1, Single Time Query = True, Enable Query Cache = True). No gasta lecturas recurrentes.
                BotonVER_Inteligente: No borra caché. Evalúa 'Nominas Documents -> Is Set and Not Empty'. 
                    - Si True: Abre 'ModalNominaAnterior' pasándole el 'Item at Index -> First'.
                    - Si False: Abre un Dialog "Sin Historial".
            }
            SincronizacionDeLecturas_PushToSync {
                El botón de 'Nómina' en el 'MenuPrincipal' es el Guardia. 
                Si encuentra una notificación hace un loop y revisa condicionales en escalon por categoría y subcategoria, y usa el 'ValorNumerico' o 'mensajeOpcional' y actualiza los App States financieros, y borra la notificación antes de dejar entrar al usuario a ver la pagina de Nomina (Solo si encuentra una notificacion con categoria 'nomina' y subcategoria 'Nueva Nomina' hace el Clear Query Cache de ).
            }
            MuestraEnPantalla {
                nombreEmpleado, numeroEmpleado, telefono, correo, sueldoAcumulado (calculadora estática), bonosPropinas, bonos, faltas, retardos, repocision, y neto a pagar (calculadora viva abajo).
                Escudo Cero Absoluto: El Balance nunca muestra números negativos.
            }
        }
        
        Asistencia {  // Ya construido | "Logica de Funcionalidad al tocarlo: #20"

            // Condicion de Visibilidad: "Encargada", "Mesera", "Cocinero
            EstructuraSuperior {
                Contenedor dividido. Izquierda: Fecha completa dinámica (ej. "Viernes 03 de marzo"). Derecha: Botón "Ver Detalles".
            }
            // Condicion de Visibilidad: "Encargada", "Mesera", "Cocinero
            EstructuraMedia_Calendario {
                Tabla estática de 7 columnas y 3 filas.
                Fila 1: Textos L, M, M, J, V, S, D. 
                Fila 2: Cuadrados de asistencia semana pasada (Calcula -7 días automáticamente).
                Fila 3: Cuadrados de asistencia semana actual.
                Cuadrado del día actual resaltado en amarillo/dorado. Colores alimentados por Custom Function leyendo Firebase.
            }
            // Condicion de Visibilidad: "Encargada", "Mesera", "Cocinero
            EstructuraInferior_Leyenda {
                Contenedor negro con la Leyenda de colores explicada en forma de lista vertical (Dorado: Esperando registro, Verde: Asistencia, Rojo: Falta, Naranja: Retardo, Blanco: Descanso/Justificada, Gris claro: Futuro, Gris oscuro: Sin registro).
            }
            BotonesInferiores {
                // Condicion de Visibilidad: "Dueño", "Encargada"
                GenerarQR {
                    Lanza un Modal (Bottom Sheet "ModalGeneradorQR") con botón "SALIR" para cerrar.
                    Muestra el QR encriptado generado con la Custom Function en tiempo real.
                }

                // Condicion de Visibilidad: "Encargada", "Mesera", "Cocinero" + "Logica de Condicion de Visibilidad: #31"
                RegistrarEntradaSalida {
                    Su texto, ícono y función cambian usando Conditional Value basado en si el turno está iniciado o no.
                    Abre la cámara para escanear el QR. 
                    Lógica Inteligente: Desencripta, valida que la fecha sea de hoy, valida la hora de duracion o validez del codigo
                }
            }
            // Condicion de Visibilidad: "Encargada", "Mesera", "Cocinero
            VerDetalles {
                Abre Componente 'ModalDetallesAsistencia'.
                Pide Component Parameter 'empleadoRef'.
                Contiene un ListView (Query a 'HistorialAsistencias', Order Decreasing, Limit 14).
            }
            
            // NOTAS Y REGLAS IMPORTANTES PARA SABER Y UTILIZAR DESPUES:
            //  Doble Variable de Estado (El Secreto de la Velocidad) {
            //      'turnoIniciado' (App State, Boolean): Es la memoria rápida. Reacciona al instante, hace que el botón de entrada cambie a salida, y ACTIVA la calculadora en tiempo real.
            //      'trabajandoActualmente' (Colección Usuarios, Boolean): Es el registro oficial en Firebase. }
            //  Ahorro de Lecturas (Caché) {
            //      La tabla de colores usa 'Single Time Query' con 'Enable Query Cache'. Solo se hace 'Clear Query Cache' al escanear entrada o salida.
            //      El Modal de Detalles usa Caché en 'App Level' para no gastar lecturas continuas. }
            //  Seguridad QR (Criptografía Simétrica) {
            //      Se arma: "LLAVE_Encargada_[NumEmpleado]_[YYYYMMDDHHMM_Inicio]_[YYYYMMDDHHMM_Fin]" inyectando "R1K0" cada 5 letras y codificado a Base64. }
            //  Limitacion de FlutterFlow Resuelta {
            //      Como FlutterFlow no permite 2 acciones de cámara QR en la pantalla, "RegistrarEntradaSalida" son físicamente un solo botón. }
            //  El Puente de Asistencia (Seguridad Máxima) {
            //      Al Registrar Entrada, el documento de 'HistorialAsistencias' se guarda en el campo 'asistenciaActualRef' del Usuario.
            //      Al Registrar Salida, lee esa referencia, actualiza la hora de salida, y limpia el campo. }
        }
        
        PuntoDeVenta { // NO construido aun

            //CondicionGlobal: Imprime tickets usando 'numeroEmpleado'.
            
            // Condicion de Acceso: "Dueño", "Encargada", "Mesera"
            AccesoDirecto {
                Entra directo a la vista del PuntoDeVenta.
                BotonIconoConfiguracion {
                    Casilla (predeterminada apagada) que si se marca, la app abre directo en PuntoDeVenta saltando el MenuPrincipal.
                    // Condicion de Visibilidad o Acceso: "Dueño", "Encargada"
                    BotonPermisos {
                        Muestra meseras y cocineros con una casilla TRUE/FALSE.
                        Al tocar la casilla da o quita permiso (True o False), el cambio e el field "UsarPDV" en la coleccion Usuarios. 
                        Si desactiva a alguien activo, le cierra la pagina PDV, lo manda al MenuPrincipal, le borra el carrito y le pasa sus tickets abiertos a la Encargada.
                    }
                }
            }
            
            // Condicion de Acceso: "Cocinero"
            AccesoRestringido {
                Verifica si tiene "UsarPDV" en TRUE para entrar al PuntoDeVenta.
                Si es FALSE {
                    Sale un "Informational Dialog" indicando que debe solicitar permisos al Dueño o Encargada.
                }
            }
        }
        
        // Condicion de Visibilidad o Acceso: "Encargada", "Mesera", "Cocinero"
        AyudaReportes { // NO construido aun
            Estructura {
                CampoTexto: "Escribe tu reporte..."
                Checkbox: "Quiero que mi reporte sea anónimo"
            }
            TextoDinamico {
                Si Checkbox == false -> "Reporte hecho por: [nombreEmpleado]"
                Si Checkbox == true -> "Reporte hecho por: Anónimo"
            }
            LogicaOculta {
                Al enviar: Guarda siempre el 'nombreEmpleado' real en la colección 'Reportes' para vista exclusiva del Dueño.
            }
        }
    }
}

// "Logica de Funcionalidad al tocarlo: #15"
Boton "Nomina" { // El del "MenuPrincipal"
    LogicaDeNavegacion_ElGuardia {
        Paso1_ConsultaNotificaciones {
            Realiza un Single Time Query a la coleccion 'Notificaciones' buscando un documento donde 'refEmpleado' sea igual al actual y 'categoria' == 'nomina'.
        }
        
        // --- ESCENARIO 5: EL ROBOT YA CERRÓ (El Sincronizado) ---
        Condicion_NotificacionExiste (True) {
            NO crea documento en Nominas (el Robot ya lo hizo a las 3:00 am).
            Update App State -> 'turnoIniciado' = False.
            Clear Query Cache -> Limpia el caché de lecturas del usuario para forzar la actualización.
            Delete Document -> Borra el documento de 'Notificaciones' de Firebase.
            Informational Dialog -> "Tu nómina ha sido cerrada automáticamente por el sistema."
            Navigate To -> Pagina Nomina.
        }

        // --- ESCENARIOS 3 Y 4: LLEGÓ TARDE O FALTÓ EL DÍA DE PAGO ---
        Condicion_CierrePendiente (False) Y (diaDePago == diaDeHoyEnEspanol) Y (trabajandoActualmente == False) Y (horaActual > horaEntradaOficial) Y (diasTrabajadosSemana > 0) {
            Lanza Modal ComponenteRojo (Advertencia de Peligro) {
                TextoMensaje {
                    "Atención: Tienes un turno pendiente de registro. Si entras a ver tu nómina ahora, el sistema registrará tu falta y cerrará la semana."
                }
                BotonA_FalteCerrarNomina {
                    Update Document (Usuarios) -> Resetea a 0 propinas, bonos, reposicion, faltas, retardos y diasTrabajadosSemana directamente en Firebase.
                    Update App State -> 'turnoIniciado' = False.
                    Clear Query Cache -> Refresca la memoria local del telefono.
                    Create Document (Nominas) -> Crea el recibo cobrando la falta (calculadoraNeto).
                    Informational Dialog -> "Tu nómina de esta semana ha sido cerrada por faltista."
                    Navigate To -> Pagina Nomina.
                }
                BotonB_LlegueTardeRegistrarAsistencia {
                    Navigate To -> Pagina Asistencia (Lo deja ir rápido a escanear su QR de entrada sin cerrar nada).
                }
            }
        }

        // --- ESCENARIOS 1 Y 2: TRABAJADOR NORMAL O TEMPRANERO ---
        Condicion_Default (Cualquier otro caso) {
            Navigate To -> Pagina Nomina. (Entra directo, su turno está activo o aún no es su hora de entrada).
        }
    }
}

// "Logica de Funcionalidad al tocarlo: #20"
Boton "Asistencia" { // El del "MenuPrincipal"
    LogicaDeNavegacion_ElGuardia {
        Paso1_ConsultaNotificaciones {
            Realiza un Single Time Query a la coleccion 'Notificaciones' buscando un documento donde 'refEmpleado' sea igual al actual y 'categoria' == 'nomina'.
        }

        // --- ESCENARIO DE SINCRONIZACIÓN AL QUERER CHECAR ---
        Condicion_NotificacionExiste (True) {
            Update App State -> 'turnoIniciado' = False.
            Clear Query Cache -> Limpia la memoria local para bajar sus contadores a 0.
            Delete Document -> Borra el documento de 'Notificaciones'.
            Informational Dialog -> "Tu nómina de la semana pasada ha sido cerrada por el sistema debido a una falta."
            Navigate To -> Pagina Asistencia.
        }

        // --- ESCENARIO NORMAL ---
        Condicion_Default (False) {
            Navigate To -> Pagina Asistencia. (Entra directo a checar entrada/salida o ver su calendario).
        }
    }

// "Logica de Condicion de Visibilidad: #31"
    LogicaInterna_Pagina "Asistencia" { 
        VisibilidadBoton "RegistrarEntradaSalida" {
            REGLA ANTI-TRAMPAS Y UX DUEÑO: 
            Ocultar el botón SI se cumple el GRUPO A o el GRUPO B (Apply Opposite Statement de un bloque OR):
            - GRUPO A (UX Dueño): 'puesto' == 'Dueño'.
            - GRUPO B (Anti-Trampas): (diaDePago == diaDeHoyEnEspanol) AND (diasTrabajadosSemana == 0) AND (trabajandoActualmente == False).
            Explicacion: El Dueño nunca necesita escanear el QR para registrar asistencia. Para los empleados, si es su dia de pago y su contador de dias está en 0, significa que su nomina acaba de ser cerrada por falta (manual o por el robot); ocultamos el boton para evitar que registren entrada y evadan la falta.
        }
    }
}


// Aplicacion exclisiva que solo la tiene instalada el "Dueño" que aun no creamos nada pero ya estamos establecioendo su mapa de navegacion y su relacion con "Riko App"
Riko Pro {
    
    InicioSesionDueño {
        Valida si existe el documento en Usuarios y si si existe el numeroEmpleado y la contrasena corresponde y si tiene el puesto "Dueño" entra a {
            MenuPrincipalDueño
        }
    }

    // Condicion de Visibilidad y Acceso: "Dueño"
    MenuPrincipalDueño {
        OpcionesVisuales {
            Que no sea tipo Dashboard - Serán los Botones verticalmente
        }
        
        GestionDePersonal {
            Acciones {
                Ver asistencias del personal.
                Editar entradas o salidas manualmente por cualquier situacion de que se le olvido registrar su entrada real.
                Crear, editar, eliminar empleados (desactivando la variable empleadoActivo en eliminar empleados para no borrar de base de datos).
                Editar su diaDeDescanso
            }

            // NOTAS Y REGLAS IMPORTANTES PARA SABER Y UTILIZAR DESPUES:
            //  Regla para crear un usuario nuevo (Riko Pro) {
            //      SÍ SE LLENA: nombreEmpleado, puesto, numeroEmpleado, contrasena, requiereCambioContrasena (True), telefono, correo, UsarPDV, sueldoSemanal, horaEntrada, horaSalida, diaDePago, diaDeDescanso, empleadoActivo (True), versionApp (Misma que versionRequerida en 'Actualizaciones').
            //      SE DEJA EN CERO/VACÍO: propinas, bonos, reposicion, faltas, sueldoAcumulado, descuentos, diasTrabajadosSemana, faltasAcumuladas, horaEntradaReal, horaSalidaReal, asistenciaActualRef. }
        }

        GestionDeNominas {
            Acciones {
                Editar sueldoSemanal y diaDePago del empleado.
                Aplicar descuentos manualmente a la nómina en curso o bonos extra.
            }

            // NOTAS Y REGLAS IMPORTANTES PARA SABER Y UTILIZAR DESPUES:
            //  Flujo de Corte de Nómina (Lógica Híbrida) {
            //      1. El Empleado usa "Riko App" y su calculadora corre en tiempo real.
            //      2. El Corte Automático: Cuando el empleado registra su SALIDA en su 'diaDePago' oficial, se hace un 'Create Document' en 'Nominas' (guardando el recibo congelado en estado "Pendiente") y resetea los contadores del empleado a 0.
            //      3. Al día siguiente, el empleado verá su sueldo actual en $0.00 y podrá consultar su nómina en el botón "Ver Recibo Anterior".
            //      4. El Dueño usa "Riko Pro" para revisar el recibo, hace el pago, y presiona "Aprobar Nómina" (Cambia estado a "Pagado" y lo envía al módulo de Finanzas). }
        }
        
        MenuYRecetas {
            Acciones {
                Crear categorias (Para el panel izquierdo del PuntoDeVenta).
                Crear productos (Para el panel derecho de la categoria).
                Crear ingredientes y recetas: Definir consumo exacto de ingredientes por producto para descontar del inventario.
            }
        }
        
        InventarioYCostos {
            Acciones {
                Crear insumos con costo por kilo, litro o unidad.
                Comprar: Añadir mercancia al inventario.
            }
            SistemaInteligentePEPS {
                Descuenta primero la mercancia del costo de compra mas antiguo.
                Al acabarse, actualiza automaticamente el precio de venta o margen basado en el costo de la nueva compra.
            }
            InventarioFisico {
                Al final del turno, comparar inventario del sistema vs fisico = Merma (Descuenta de ganancia en categoria merma).
            }
        }
        
        ReportesDelPersonal {
            Acciones {
                Ver los reportes anonimos del personal (mostrando el nombre real del empleado sin importar si fue anonimo el reporte).
            }
        }

        Finanzas {
            DineroTotal {
                Dinero en efectivo y tarjeta, quiero saber qué dinero es para reinvertir, pagar gastos fijos o no fijos, y qué dinero es mi ganancia real neta.
            }
            Resumen {
                Resumen de ventas por hora, dia, empleado. 
            }
        }
    }
}