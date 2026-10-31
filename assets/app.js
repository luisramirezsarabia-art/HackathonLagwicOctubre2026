// Conexión con la plataforma (Supabase). La llave publicable solo puede llamar a las funciones controladas.
const API = 'https://oqrspsmoaeozbhflccbs.supabase.co/rest/v1/rpc/';
const KEY = 'sb_publishable_PKNGZbi_WZObhkGW3OkO-w_7lNfy7cZ';
const ALERTIA_TEL = '+526692701810';

async function rpc(nombre, datos) {
  const r = await fetch(API + nombre, {
    method: 'POST',
    headers: { apikey: KEY, Authorization: 'Bearer ' + KEY, 'Content-Type': 'application/json' },
    body: JSON.stringify(datos || {})
  });
  const txt = await r.text();
  const cuerpo = txt ? JSON.parse(txt) : null;
  if (!r.ok) throw new Error((cuerpo && cuerpo.message) || 'Error de conexión');
  return cuerpo;
}

// Teléfono mexicano → formato internacional para WhatsApp
function telWA(t) {
  const crudo = String(t || '').trim();
  const d = crudo.replace(/\D/g, '');
  if (crudo.startsWith('+')) return d;          // ya trae lada de país (turistas: +1 …)
  return d.length === 10 ? '52' + d : d;      // 10 dígitos sin «+»: celular mexicano
}

function esc(s) {
  return String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}

const LOGO = `<svg class="pulso" viewBox="0 0 68 40" aria-hidden="true"><path d="M2 22h18l5-12 8 24 7-30 6 18h20" stroke="#AAFF00" stroke-width="4" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
