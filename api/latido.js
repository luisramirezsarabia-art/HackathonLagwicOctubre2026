// Latido diario (Vercel Cron): una consulta ligera mantiene activa la base de Supabase,
// que en el plan gratuito se pausa tras 7 días sin uso.
export default async function handler(req, res) {
  const KEY = 'sb_publishable_PKNGZbi_WZObhkGW3OkO-w_7lNfy7cZ';
  try {
    const r = await fetch('https://oqrspsmoaeozbhflccbs.supabase.co/rest/v1/rpc/biker_estado_chip', {
      method: 'POST',
      headers: { apikey: KEY, Authorization: 'Bearer ' + KEY, 'Content-Type': 'application/json' },
      body: JSON.stringify({ p_id: 'DEMO2027' })
    });
    res.status(r.ok ? 200 : 502).json({ ok: r.ok, supabase: r.status, hora: new Date().toISOString() });
  } catch (e) {
    res.status(502).json({ ok: false, error: String(e) });
  }
}
