// Screen 9 — Session History Detail
// Completed session receipt + credits earned + dispute entry point.

function SessionHistoryScreen() {
  const [logsOpen, setLogsOpen] = useState(false);
  const [toast, setToast] = useState(null);

  const showToast = (msg) => {
    setToast(msg);
    setTimeout(() => setToast(null), 2200);
  };

  const logs = [
    { t: '4:00 PM', l: 'Session started · Seat 3' },
    { t: '4:03 PM', l: 'System activity detected' },
    { t: '5:55 PM', l: '5-min warning sent' },
    { t: '6:02 PM', l: 'Session ended' },
    { t: '6:02 PM', l: 'Credits awarded · +102' },
  ];

  return (
    <Phone>
      <TopBar title="Session details" subtitle="#SES-20945" onBack={() => {}}
        trailing={<IconBtn>{I.info}</IconBtn>} />

      <Scroll>
        {/* status banner */}
        <div style={{
          padding: '14px 18px',
          background: 'var(--gz-ok-bg)', color: 'var(--gz-ok)',
          borderRadius: 18, marginBottom: 12,
          display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{
            width: 34, height: 34, borderRadius: 999,
            background: 'rgba(255,255,255,0.55)',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          }}>
            {React.cloneElement(I.check, { style: { width: 18, height: 18 } })}
          </div>
          <div style={{ flex: 1 }}>
            <div className="gz-h3" style={{ color: 'inherit' }}>Completed</div>
            <div className="gz-small" style={{ color: 'inherit', opacity: 0.75, marginTop: 1 }}>
              18 Apr · 2 hrs 2 min
            </div>
          </div>
          <span className="gz-num gz-h2" style={{ color: 'inherit' }}>₹102</span>
        </div>

        {/* summary card */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14 }}>
            <div className="gz-tile gz-tile--sq" style={{ width: 42, height: 42, background: 'var(--gz-fg)', color: '#fff' }}>
              {React.cloneElement(I.pc, { style: { width: 20, height: 20 } })}
            </div>
            <div>
              <div className="gz-h3">RTX 4090 — Seat 3</div>
              <div className="gz-small" style={{ marginTop: 2 }}>GameZone Koramangala</div>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            <span className="gz-chip"><span className="gz-chip__k">DATE</span>18 Apr</span>
            <span className="gz-chip"><span className="gz-chip__k">PAID</span>UPI</span>
            <span className="gz-chip"><span className="gz-chip__k">ID</span>SES-20945</span>
          </div>
        </div>

        {/* time block */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 12 }}>DURATION</div>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 12 }}>
            <div>
              <div className="gz-meta" style={{ marginBottom: 4 }}>START</div>
              <div className="gz-body gz-num" style={{ fontWeight: 700 }}>4:00 PM</div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div className="gz-meta" style={{ marginBottom: 4 }}>DURATION</div>
              <div className="gz-body gz-num" style={{ fontWeight: 700 }}>2h 02m</div>
            </div>
            <div style={{ textAlign: 'right' }}>
              <div className="gz-meta" style={{ marginBottom: 4 }}>END</div>
              <div className="gz-body gz-num" style={{ fontWeight: 700 }}>6:02 PM</div>
            </div>
          </div>
          <div style={{ position: 'relative', height: 6, background: 'var(--gz-rule)', borderRadius: 999, overflow: 'hidden' }}>
            <div style={{ position: 'absolute', inset: 0, background: 'var(--gz-fg)' }} />
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 8 }}>
            <span className="gz-small">Booked 2:00 PM</span>
            <span className="gz-small">+2 min overtime</span>
          </div>
        </div>

        {/* billing breakdown */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 12 }}>BILLING</div>
          <MetaRow label="Base · ₹80/hr × 2"      value="₹160" />
          <MetaRow label="Peak hour surcharge"     value="+ ₹20" />
          <MetaRow label="Campaign · Happy Hour"   value={<span style={{ color: 'var(--gz-ok)' }}>− ₹48</span>} />
          <MetaRow label="Credits redeemed · 300"  value={<span style={{ color: 'var(--gz-ok)' }}>− ₹30</span>} />
          <hr className="gz-hr gz-hr--thick" style={{ margin: '10px 0' }} />
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span className="gz-h3">Total charged</span>
            <span className="gz-hero-md">₹102</span>
          </div>
          <div className="gz-small" style={{ marginTop: 8 }}>
            Paid via <span style={{ color: 'var(--gz-fg)', fontWeight: 600 }}>UPI</span> · gpay@okaxis
          </div>
        </div>

        {/* credits earned — mint hero */}
        <div className="gz-card gz-card--tint" style={{ marginBottom: 12, padding: 18 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 12 }}>
            <div style={{
              width: 36, height: 36, borderRadius: 999,
              background: 'rgba(255,255,255,0.5)', color: 'var(--gz-ok)',
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            }}>
              {React.cloneElement(I.spark, { style: { width: 18, height: 18 } })}
            </div>
            <div className="gz-meta" style={{ color: 'var(--gz-fg-2)' }}>CREDITS EARNED</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
            <span className="gz-hero-md">+102</span>
            <span className="gz-body" style={{ color: 'var(--gz-fg-2)' }}>from this session</span>
          </div>
          <div style={{ height: 1, background: 'rgba(10,10,10,0.08)', margin: '14px 0' }} />
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>Balance at this store</span>
            <span className="gz-body gz-num" style={{ fontWeight: 700 }}>850 credits</span>
          </div>
        </div>

        {/* session logs */}
        <div className="gz-card" style={{ marginBottom: 12, padding: 0 }}>
          <button onClick={() => setLogsOpen(o => !o)}
            style={{ width: '100%', background: 'transparent', border: 0, padding: '16px 18px',
              display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <span style={{ display: 'inline-flex', alignItems: 'center', gap: 10 }}>
              {React.cloneElement(I.list, { style: { width: 18, height: 18 } })}
              <span className="gz-body" style={{ fontWeight: 600 }}>
                <span className="gz-num">{logs.length}</span> events logged
              </span>
            </span>
            <span style={{ transform: logsOpen ? 'rotate(180deg)' : 'none', transition: 'transform .2s', display: 'inline-flex', color: 'var(--gz-fg-3)' }}>
              {I.chevDn}
            </span>
          </button>
          {logsOpen && (
            <div style={{ padding: '0 18px 14px' }}>
              {logs.map((e, i) => (
                <div key={i} style={{ display: 'flex', gap: 12, padding: '8px 0',
                  borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)' }}>
                  <span className="gz-small gz-num" style={{ width: 64, flexShrink: 0 }}>{e.t}</span>
                  <span className="gz-body" style={{ fontSize: 13 }}>{e.l}</span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* bottom actions */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginTop: 4 }}>
          <button className="gz-btn gz-btn--ghost"
            onClick={() => showToast('Receipt sent to your email')}>
            {React.cloneElement(I.dl, { style: { width: 18, height: 18 } })} Download receipt
          </button>
          <button className="gz-btn gz-btn--danger-outline gz-btn--sm"
            style={{ width: 'auto', alignSelf: 'center', padding: '0 18px', marginTop: 6 }}>
            File a dispute
          </button>
          <div className="gz-small" style={{ textAlign: 'center', marginTop: 2 }}>
            Disputes accepted within 7 days · <span className="gz-num">5 days left</span>
          </div>
        </div>
      </Scroll>

      {toast && (
        <div style={{
          position: 'absolute', left: 16, right: 16, bottom: 24,
          padding: '12px 16px', borderRadius: 14,
          background: 'var(--gz-fg)', color: '#fff',
          display: 'flex', alignItems: 'center', gap: 10,
          animation: 'gz-slide-up 0.18s cubic-bezier(.2,.7,.3,1)',
          zIndex: 80,
        }}>
          <span style={{ color: 'var(--gz-card-tint-strong)' }}>
            {React.cloneElement(I.check, { style: { width: 18, height: 18 } })}
          </span>
          <span style={{ fontSize: 13, fontWeight: 600 }}>{toast}</span>
        </div>
      )}
    </Phone>
  );
}

Object.assign(window, { SessionHistoryScreen });
