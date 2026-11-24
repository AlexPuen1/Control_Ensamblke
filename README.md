# Control Ensamble - Cobots

Dashboard de monitoreo de ensamble. Extrae y sincroniza automáticamente los datos de la tabla de Ignition mediante Edge/Chrome y los sirve en una interfaz web local.

---

## 🚀 Cómo ejecutar en Windows (Sin escribir comandos)

Tienes varias opciones para ejecutar el sistema con solo dar doble clic:

### Opción 1: Iniciar normal (Recomendado)
- Haz doble clic en el archivo **`iniciar.bat`**.
- Se abrirá la consola mostrando el estado, instalará dependencias si es la primera vez, y abrirá automáticamente el navegador en [http://localhost:3000](http://localhost:3000).

### Opción 2: Iniciar en segundo plano (Silencioso)
- Haz doble clic en el archivo **`iniciar_segundo_plano.vbs`**.
- Ejecutará el servidor de forma totalmente oculta (sin mostrar la ventana negra de la consola) y abrirá el navegador.

### Opción 3: Iniciar automáticamente al encender la PC
- Haz doble clic en **`configurar_inicio_con_windows.bat`**.
- Podrás activar o desactivar que el sistema se inicie solo cada vez que enciendas o inicies sesión en Windows.

---

## ⚙️ Requisitos
- [Node.js](https://nodejs.org/) (versión 18 o superior).
- Microsoft Edge o Google Chrome instalado en el sistema.
- Acceso de red al servidor de Ignition (`http://est01ignition:8088/...`).
