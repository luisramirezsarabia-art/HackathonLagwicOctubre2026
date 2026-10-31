-- Copia de la migración aplicada en Supabase (proyecto oqrspsmoaeozbhflccbs, "Hackathon Lawgic Octubre 2026"), 31-oct-2026.
-- Tablas con RLS activo y SIN políticas: el rol anon no puede leer ni escribir directo. Todo pasa por funciones security definer.
create table public.biker_motociclistas (
  id text primary key, nombre text not null, apellido text, celular text, moto text,
  sangre text, mostrar_sangre boolean default true, alerta_critica text, mostrar_alerta boolean default true,
  alergias text, padecimientos text, medicamentos text, seguro text, medico text, donador boolean default false,
  contacto1_nombre text not null, contacto1_parentesco text, contacto1_tel text not null,
  contacto2_nombre text, contacto2_parentesco text, contacto2_tel text,
  consentimiento_datos boolean not null default false, consentimiento_alertas boolean not null default false,
  consentimiento_promos boolean not null default false, created_at timestamptz default now());
create table public.biker_eventos (
  id bigserial primary key, moto_id text references public.biker_motociclistas(id) on delete cascade,
  tipo text not null check (tipo in ('escaneo','whatsapp','llamada_familia','llamada_911','paramedico')),
  lat double precision, lng double precision, created_at timestamptz default now());
alter table public.biker_motociclistas enable row level security;
alter table public.biker_eventos enable row level security;

-- biker_registrar(p jsonb) → id de 8 caracteres hex (md5(random()||clock_timestamp())). Exige consentimientos de datos y alertas. Recorta longitudes.
-- biker_ficha_publica(p_id) → nombre, moto, sangre (si mostrar_sangre), alerta_critica (si mostrar_alerta), contactos 1 y 2 con teléfono.
-- biker_ficha_clinica(p_id, p_codigo) → si p_codigo = código de piloto (8 dígitos), con bloqueo tras 5 fallos en 10 min devuelve nombre completo, sangre, alergias, padecimientos, medicamentos, seguro, médico, donador; registra evento 'paramedico'.
-- biker_evento(p_id, p_tipo, p_lat, p_lng) → inserta evento si el id existe.
-- biker_tablero(p_codigo) → si p_codigo = código largo del centro devuelve últimos 60 eventos con nombre e inicial, moto y nombre del contacto (sin teléfonos), total de registrados y escaneos 24 h.
-- Permisos: revoke all from public; grant execute to anon, authenticated.

-- Chips de fábrica (31-oct-2026):
-- biker_chips(id, codigo_activacion, lote, estado 'impreso'|'activo'|'suspendido', created_at, activado_at) con RLS sin políticas.
-- biker_generar_lote(p_codigo, p_cantidad ≤60, p_lote) → [{id, codigo}] (solo con el código del centro).
-- biker_estado_chip(p_id) → 'activo' | 'sin_activar' | 'suspendido' | 'no_existe'.
-- biker_registrar(p) con chip_id + codigo_activacion activa ese chip (una sola vez; 5 fallos en 10 min = bloqueo); sin chip, genera uno en línea.
-- biker_ubicar(p_id, lat, lng) → agrega la ubicación tardía al último escaneo sin coordenadas (15 min).
-- biker_intentos(moto_id, exito, created_at): bitácora de intentos de código clínico y de activación.
