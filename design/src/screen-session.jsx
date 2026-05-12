// Screen 2 — Active Session
// Live timer (counts down), running cost, events teaser, support actions.

function ActiveSessionScreen() {
  const TOTAL = 2 * 60 * 60;            // 2h in seconds
  const START_ELAPSED = 23 * 60 + 56;   // 23m 56s elapsed
  const [elapsed, setElapsed] = useState(START_ELAPSED);
  const [showEvents, setShowEvents] = useState(false);

  useEffect(() => {
    const t = setInterval(() => {
      setElapsed(e => Math.min(TOTAL, e + 1));
    }, 1000);
    return () => clearInterval(t);
  }, []);

  const remain = Math.max(0, TOTAL - elapsed);
  const pad = (n) => String(n).padStart(2, '0');
  const remainStr = `${Math.floor(remain / 3600)}:${pad(Math.floor((remain % 3600) / 60))}:${pad(remain % 60)}`;
  const elapsedStr = `${pad(Math.floor(elapsed / 60))}:${pad(elapsed % 60)}`;
  const pct = elapsed / TOTAL;
  const cost = (elapsed / 3600) * 80;

  return (
    <Phone>
      <TopBar
        title={<span style={{ display: 'inline-flex', alignItems: 'center', gap: 8 }}>
          <span className="gz-dot-pulse" /> Live session
        </span>}
        subtitle="GameZone · Koramangala"
        onBack={() => {}} disabledBack
        trailing={<IconBtn>{I.bell}</IconBtn>} />

      <Scroll>
        {/* hero timer card — mint tint, the focal point */}
        <div className="gz-card gz-card--tint" style={{ padding: 24, marginBottom: 12, textAlign: 'center' }}>
          <div className="gz-meta" style={{ marginBottom: 14, color: 'var(--gz-fg-2)' }}>TIME REMAINING</div>
          <div className="gz-hero" style={{ fontSize: 64, marginBottom: 6 }}>{remainStr}</div>
          <div className="gz-body" style={{ color: 'var(--gz-fg-2)', marginBottom: 18 }}>
            <span className="gz-num">{elapsedStr}</span> elapsed of <span className="gz-num">2:00:00</span>
          </div>

          {/* progress arc — using stroke-dashoffset on SVG */}
          <ProgressArc pct={pct} />

          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 14, padding: '0 4px' }}>
            <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>Started 4:00 PM</span>
            <span className="gz-small gz-num" style={{ fontWeight: 700, color: 'var(--gz-fg)' }}>
              {(pct * 100).toFixed(0)}%
            </span>
            <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>Ends 6:00 PM</span>
          </div>
        </div>

        {/* session details */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', marginBottom: 14 }}>
            <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
              <div className="gz-tile gz-tile--sq" style={{ width: 42, height: 42, background: 'var(--gz-fg)', color: '#fff' }}>
                {React.cloneElement(I.pc, { style: { width: 20, height: 20 } })}
              </div>
              <div>
                <div className="gz-h3">RTX 4090 Gaming PC</div>
                <div className="gz-small" style={{ marginTop: 3 }}>GameZone Koramangala</div>
              </div>
            </div>
            <Tag kind="ok">Active</Tag>
          </div>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            <span className="gz-chip"><span className="gz-chip__k">SEAT</span>3</span>
            <span className="gz-chip"><span className="gz-chip__k">PLAT</span>PC</span>
            <span className="gz-chip"><span className="gz-chip__k">ID</span>SES-20948</span>
          </div>
        </div>

        {/* running cost */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 6 }}>
            <span className="gz-meta">RUNNING TOTAL</span>
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
              <span className="gz-dot-pulse" style={{ width: 6, height: 6 }} />
              <span className="gz-small" style={{ color: 'var(--gz-ok)', fontWeight: 600 }}>live</span>
            </span>
          </div>
          <div className="gz-hero-md" style={{ marginTop: 4 }}>₹{cost.toFixed(2)}</div>
          <div className="gz-small" style={{ marginTop: 4 }}>
            <span className="gz-num">₹80/hr</span> · <span className="gz-num">{Math.floor(elapsed / 60)}m {elapsed % 60}s</span> elapsed
          </div>
          <div style={{
            marginTop: 12, padding: '10px 12px',
            background: 'var(--gz-pill-bg)', borderRadius: 10,
            fontSize: 12, color: 'var(--gz-fg-2)',
          }}>
            Final bill is calculated by the system at session end.
          </div>
        </div>

        {/* events */}
        <div className="gz-card" style={{ marginBottom: 12, padding: 0 }}>
          <button onClick={() => setShowEvents(s => !s)}
            style={{ width: '100%', background: 'transparent', border: 0, padding: '16px 20px',
              display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 10 }}>
              {React.cloneElement(I.list, { style: { width: 18, height: 18 } })}
              <span className="gz-body" style={{ fontWeight: 600 }}>4 events logged</span>
            </span>
            <span style={{ transform: showEvents ? 'rotate(180deg)' : 'none', transition: 'transform .2s', display: 'inline-flex', color: 'var(--gz-fg-3)' }}>{I.chevDn}</span>
          </button>
          {showEvents && (
            <div style={{ padding: '0 20px 16px' }}>
              {[
                { t: '04:00 PM', l: 'Session started · Seat 3' },
                { t: '04:08 PM', l: 'System activity detected' },
                { t: '04:18 PM', l: 'Steam launch · CS2' },
                { t: '04:23 PM', l: '5-min warning sent · ignore if continuing' },
              ].map((e, i) => (
                <div key={i} style={{ display: 'flex', gap: 12, padding: '8px 0', borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)' }}>
                  <span className="gz-small gz-num" style={{ width: 64, flexShrink: 0 }}>{e.t}</span>
                  <span className="gz-body" style={{ color: 'var(--gz-fg)', fontSize: 13 }}>{e.l}</span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* extend info card */}
        <div className="gz-card" style={{ marginBottom: 12, display: 'flex', gap: 12, alignItems: 'flex-start' }}>
          <div className="gz-tile" style={{ background: 'var(--gz-warn-bg)', color: 'var(--gz-warn)', flexShrink: 0 }}>
            {React.cloneElement(I.staff, { style: { width: 20, height: 20 } })}
          </div>
          <div>
            <div className="gz-h3" style={{ marginBottom: 4 }}>Need more time?</div>
            <div className="gz-body-r" style={{ fontSize: 13 }}>
              Walk up to the counter — staff will extend your session in person. No app extension yet.
            </div>
          </div>
        </div>

        {/* bottom support actions */}
        <div style={{ display: 'flex', gap: 10, marginBottom: 4 }}>
          <button className="gz-btn gz-btn--ghost" style={{ height: 48, fontSize: 14 }}>
            {React.cloneElement(I.chat, { style: { width: 18, height: 18 } })} Chat support
          </button>
          <button className="gz-btn gz-btn--danger-outline" style={{ height: 48, fontSize: 14, maxWidth: 130 }}>
            {React.cloneElement(I.sos, { style: { width: 16, height: 16 } })} SOS
          </button>
        </div>
      </Scroll>

      <BottomNav active="games" />
    </Phone>
  );
}

function ProgressArc({ pct }) {
  const r = 90, c = 2 * Math.PI * r;
  const offset = c * (1 - pct);
  return (
    <div style={{ position: 'relative', width: '100%', height: 8 }}>
      <div className="gz-progress" style={{ height: 8, background: 'rgba(10,10,10,0.08)' }}>
        <i style={{ width: `${pct * 100}%`, background: 'var(--gz-fg)', transition: 'width 1s linear' }} />
      </div>
    </div>
  );
}

Object.assign(window, { ActiveSessionScreen });
