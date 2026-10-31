# Alertia Biker · El chip que salva vidas

**Hackathon Lawgic · Octubre 2026** · MVP en vivo: **https://alertia-biker.vercel.app**

Alertia Biker es un chip QR gratuito para el casco del motociclista, respaldado por **Alertia 724**, empresa de ambulancias privadas en Mazatlán, Sinaloa. Cuando un motociclista queda inconsciente en un accidente, cualquier celular puede escanear su casco **sin instalar una app** para:

- ver su **ficha de emergencia** (capa pública mínima: nombre de pila y, solo si él lo autoriza, tipo de sangre y una alerta crítica);
- **llamar al 911**, a su familia o a Alertia 724 con un toque;
- **avisar a su familia por WhatsApp** con la ubicación;
- dar al **personal autorizado** de Alertia acceso a la ficha clínica (alergias, padecimientos, medicamentos, seguro), con bloqueo de intentos y bitácora.

El **centro de monitoreo** de Alertia 724 ve cada escaneo en un mapa en tiempo real.

## Problema

- En México hay **10.5 millones de motos registradas**, cuatro veces más que en 2015 (INEGI, VMRC 2025).
- Los motociclistas son el **17.2 % de las muertes viales** (Secretaría de Salud, STCONAPRA, 2023).
- En Mazatlán, ~7 de cada 10 atenciones por turno de Cruz Roja son percances de moto (Punto.mx, dic. 2025).

Cuando el motociclista no puede hablar, nadie sabe su tipo de sangre ni a quién avisar.

## Pantallas

| Ruta | Qué hace |
|---|---|
| `/` | Página principal con Alertín, el embajador de Alertia 724 |
| `/registro` | Registro en 3 pasos con consentimientos; genera el chip QR |
| `/registro?chip=ID` | Activación de un **chip de fábrica** con su código de 6 dígitos |
| `/e/ID` | Ficha de emergencia que abre el QR (español e inglés). Si el chip es nuevo, invita a activarlo |
| `/centro` | Tablero en vivo del centro de monitoreo (requiere código) |
| `/lote` | Genera hojas de chips de fábrica para repartir en eventos (requiere código) |
| `/chip?id=ID` | Chip imprimible |

## Dos formas de obtener el chip

1. **Chip de fábrica:** Alertia imprime chips por lote y los reparte en eventos o talleres. El motociclista escanea su chip nuevo, lo activa con sus datos y su código de activación, y lo pega en el casco. Un chip solo se activa una vez.
2. **Registro en línea:** el motociclista se registra en el sitio y recibe un chip para imprimir.

## Privacidad y seguridad (diseñado conforme a la LFPDPPP 2025)

- **Privacidad por capas:** pública mínima / clínica con código de personal / privada.
- Consentimiento **expreso y por separado** para los datos de salud, para el aviso a contactos y, de forma opcional, para promociones.
- Aviso de privacidad simplificado en el registro y aviso al testigo sobre el uso de su ubicación.
- Base de datos en **Supabase (PostgreSQL)** con **RLS activo y sin políticas**: nadie lee ni escribe las tablas de forma directa. Todo pasa por funciones `security definer` que solo devuelven lo autorizado (`supabase/esquema.sql`).
- **Límites anti-abuso:**
  - el código clínico se bloquea tras 5 intentos fallidos en 10 minutos;
  - el código de activación tiene el mismo límite;
  - máximo 10 eventos por chip por minuto;
  - el evento «personal» solo nace de la ficha clínica.
- El tablero no muestra teléfonos. Toda salida se escapa contra XSS.

> Es un MVP de hackathon. En producción: credencial individual por paramédico, aviso de privacidad integral, autenticación reforzada del consentimiento, NFC de respaldo y WhatsApp automático vía API oficial.

## Tecnología

- Sitio estático (HTML, CSS y JavaScript, sin frameworks) en **Vercel**.
- **Supabase** (PostgreSQL, funciones RPC) como base de datos y API.
- QR con qrcodejs, mapa con Leaflet + OpenStreetMap, geolocalización del navegador con permiso.
- Paleta oficial de Alertia 724: verde neón `#AAFF00`, navy `#0D1B2A` y grises claros.

## Equipo

Proyecto para **Alertia 724** (Mazatlán, Sinaloa). Diseño, estudio de mercado y desarrollo: Ingeniería Jurídica Digital® · ClickLegal.
Los datos que aparecen en la demo son ficticios.
