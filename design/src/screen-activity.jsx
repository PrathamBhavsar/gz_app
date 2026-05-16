// Screen 3 — Activity Hub
// Top tabs: Upcoming · Active · History. Floating live session banner on Upcoming.

function ActivityHubScreen() {
  const [tab, setTab] = useState('upcoming');
  const [paySheet, setPaySheet] = useState(false);
  const [expandedHist, setExpandedHist] = useState(null);

  const [elapsed, setElapsed] = useState(23 * 60 + 56);
  useEffect(() => {
    const t = setInterval(() => setElapsed(e => e + 1), 1000);
    return () => clearInterval(t);
  }, []);
  const remain = 2 * 3600 - elapsed;
  const remStr = `${Math.floor(remain / 3600)}h ${String(Math.floor((remain % 3600) / 60)).padStart(2, '0')}m`;

  return (
    <Phone>
      <div style={{ padding: '4px 16px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}>
        <h1 className="gz-title">My games</h1>
        <div style={{ display: 'flex', gap: 4 }}>
          <IconBtn>{I.filter}</IconBtn>
          <IconBtn>{I.bell}</IconBtn>
        </div>
      </div>

      {/* tab navigator */}
      <div style={{ padding: '12px 16px 4px', flexShrink: 0 }}>
        <div style={{
          display: 'flex', gap: 4, padding: 4,
          background: 'var(--gz-pill-bg)', borderRadius: 14,
        }}>
          {[
            { id: 'upcoming', label: 'Upcoming', count: 2 },
            { id: 'active',   label: 'Active',   count: 1, dot: true },
            { id: 'history',  label: 'History',  count: null },
          ].map(t => (
            <button key={t.id} onClick={() => setTab(t.id)}
              style={{
                flex: 1, height: 40, border: 0,
                background: tab === t.id ? 'var(--gz-card)' : 'transparent',
                color: tab === t.id ? 'var(--gz-fg)' : 'var(--gz-fg-3)',
                borderRadius: 10, fontSize: 13, fontWeight: 600,
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 6,
                boxShadow: tab === t.id ? '0 1px 3px rgba(0,0,0,0.06)' : 'none',
                transition: 'all .15s',
              }}>
              {t.dot && tab === t.id && <span className="gz-dot-pulse" style={{ width: 6, height: 6 }} />}
              {t.label}
              {t.count != null && <span style={{
                fontSize: 11, fontWeight: 600,
                background: tab === t.id ? 'var(--gz-fg)' : 'transparent',
                color: tab === t.id ? '#fff' : 'var(--gz-fg-3)',
                padding: '1px 6px', borderRadius: 999, minWidth: 18,
              }}>{t.count}</span>}
            </button>
          ))}
        </div>
      </div>

      <Scroll>
        {tab === 'upcoming' && (
          <>
            {/* live session floating banner */}
            <button onClick={() => setTab('active')}
              className="gz-card gz-card--tint"
              style={{ width: '100%', padding: 16, border: 0, textAlign: 'left',
                display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14,
                cursor: 'pointer' }}>
              <Avatar size="lg" bg="var(--gz-fg)">
                <span className="gz-dot-pulse" style={{ background: 'var(--gz-card-tint-strong)' }} />
              </Avatar>
              <div style={{ flex: 1 }}>
                <div className="gz-body" style={{ fontWeight: 700 }}>Session live now</div>
                <div className="gz-small" style={{ marginTop: 2 }}>
                  RTX 4090 · <span className="gz-num">{remStr}</span> remaining
                </div>
              </div>
              <span style={{ color: 'var(--gz-fg)' }}>{I.chev}</span>
            </button>

            {/* booking card 1: confirmed */}
            <BookingCard
              icon={I.pc}
              system="RTX 4090 PC — Seat 3"
              store="GameZone Koramangala"
              when="Tomorrow · 4:00 – 6:00 PM"
              duration="2h"
              status={<Tag kind="ok">Confirmed</Tag>}
              countdown="Starts in 18h 24m"
              actions={[
                { label: 'Check in',  disabled: true,  ghost: true },
                { label: 'Cancel',    ghost: true },
              ]} />

            {/* booking card 2: payment pending */}
            <BookingCard
              icon={I.ps}
              system="PS5 Console — Seat 1"
              store="GameZone MG Road"
              when="Sat, 20 Apr · 6:00 – 7:00 PM"
              duration="1h"
              status={<Tag kind="warn">Payment pending</Tag>}
              countdown={<span style={{ color: 'var(--gz-warn)' }}>Pay before tomorrow 11 PM</span>}
              actions={[
                { label: 'Pay now',  primary: true, attn: true, onClick: () => setPaySheet(true) },
                { label: 'Cancel',   ghost: true },
              ]} />

            {/* empty state */}
            <div style={{ textAlign: 'center', padding: '32px 20px 8px' }}>
              <div style={{ display: 'inline-flex', margin: '0 auto 14px' }}>
                <div style={{
                  width: 56, height: 56,
                  borderRadius: 14, background: 'var(--gz-pill-bg)',
                  display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                  color: 'var(--gz-fg-3)',
                }}>
                  {React.cloneElement(I.cal, { style: { width: 26, height: 26 } })}
                </div>
              </div>
              <div className="gz-h3" style={{ marginBottom: 4 }}>No more upcoming bookings</div>
              <div className="gz-small" style={{ marginBottom: 14 }}>Find a slot for the weekend</div>
              <button className="gz-btn gz-btn--ghost" style={{ width: 'auto', display: 'inline-flex' }}>
                Book a slot {I.chev}
              </button>
            </div>
          </>
        )}

        {tab === 'active' && (
          <>
            <div className="gz-card gz-card--tint" style={{ padding: 22, marginBottom: 12 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 14 }}>
                <span className="gz-dot-pulse" />
                <span className="gz-meta" style={{ color: 'var(--gz-ok)' }}>LIVE NOW</span>
              </div>
              <div className="gz-h2" style={{ marginBottom: 4 }}>RTX 4090 — Seat 3</div>
              <div className="gz-small" style={{ marginBottom: 18 }}>GameZone Koramangala</div>

              <div style={{ textAlign: 'center', padding: '8px 0 4px' }}>
                <div className="gz-meta" style={{ marginBottom: 8, color: 'var(--gz-fg-2)' }}>REMAINING</div>
                <div className="gz-hero">{`${Math.floor(remain / 3600)}:${String(Math.floor((remain % 3600) / 60)).padStart(2, '0')}:${String(remain % 60).padStart(2, '0')}`}</div>
              </div>

              <div className="gz-progress" style={{ background: 'rgba(10,10,10,0.1)', height: 6, marginTop: 18 }}>
                <i style={{ width: `${(elapsed / 7200) * 100}%`, background: 'var(--gz-fg)' }} />
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 10 }}>
                <span className="gz-small">₹{((elapsed / 3600) * 80).toFixed(2)} so far</span>
                <span className="gz-small">{((elapsed / 7200) * 100).toFixed(0)}% complete</span>
              </div>
            </div>

            <button className="gz-btn">Open session {I.chev}</button>
            <div className="gz-small" style={{ textAlign: 'center', marginTop: 10 }}>
              Live cost will keep accumulating until you check out
            </div>
          </>
        )}

        {tab === 'history' && (
          <>
            <MonthHeader>April 2026</MonthHeader>
            <HistoryRow id="h1" store="GameZone Koramangala" system="RTX 4090" dur="2h" cost="₹160" status="completed" expanded={expandedHist} setExpanded={setExpandedHist} />
            <HistoryRow id="h2" store="GameZone MG Road"     system="PS5"      dur="1.5h" cost="₹90"  status="completed" expanded={expandedHist} setExpanded={setExpandedHist} />
            <HistoryRow id="h3" store="GameZone Koramangala" system="Xbox"     dur="—"   cost="₹0"   status="cancelled" expanded={expandedHist} setExpanded={setExpandedHist} />
            <MonthHeader>March 2026</MonthHeader>
            <HistoryRow id="h4" store="GameZone Koramangala" system="VR Rig"   dur="1h"   cost="₹200" status="completed" expanded={expandedHist} setExpanded={setExpandedHist} />
            <HistoryRow id="h5" store="GameZone HSR"         system="RTX 3080" dur="3h"   cost="₹240" status="completed" expanded={expandedHist} setExpanded={setExpandedHist} />
            <button className="gz-btn gz-btn--ghost" style={{ marginTop: 12 }}>Load more</button>
          </>
        )}
      </Scroll>

      <BottomNav active="games" />

      {paySheet && (
        <div className="gz-sheet-overlay" onClick={() => setPaySheet(false)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 4 }}>Complete payment</div>
            <div className="gz-body-r" style={{ marginBottom: 18 }}>PS5 Console · Sat, 20 Apr</div>

            <div className="gz-card gz-card--inset" style={{ marginBottom: 14, background: 'var(--gz-pill-bg)' }}>
              <MetaRow label="Booking" value="₹90" />
              <MetaRow label="Convenience fee" value="₹2" />
              <hr className="gz-hr" style={{ margin: '6px 0' }} />
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                <span className="gz-h3">Total</span>
                <span className="gz-hero-md">₹92</span>
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginBottom: 14 }}>
              {['UPI', 'Card', 'Credits'].map((p, i) => (
                <button key={p} style={{
                  height: 48, border: 0, borderRadius: 12,
                  background: i === 0 ? 'var(--gz-fg)' : 'var(--gz-pill-bg)',
                  color: i === 0 ? '#fff' : 'var(--gz-fg)',
                  fontWeight: 600, fontSize: 13,
                }}>{p}</button>
              ))}
            </div>

            <button className="gz-btn">Pay ₹92</button>
          </div>
        </div>
      )}
    </Phone>
  );
}

function BookingCard({ icon, system, store, when, duration, status, countdown, actions }) {
  return (
    <div className="gz-card" style={{ marginBottom: 12 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 14 }}>
        <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
          <Avatar size="lg" bg="var(--gz-pill-bg)" iconColor="var(--gz-fg)" icon={icon} />
          <div>
            <div className="gz-body" style={{ fontWeight: 700 }}>{system}</div>
            <div className="gz-small" style={{ marginTop: 2 }}>{store}</div>
          </div>
        </div>
        {status}
      </div>

      <div style={{ display: 'flex', gap: 6, marginBottom: 14, flexWrap: 'wrap' }}>
        <span className="gz-chip"><span className="gz-chip__k">WHEN</span>{when}</span>
        <span className="gz-chip"><span className="gz-chip__k">FOR</span>{duration}</span>
      </div>

      <div className="gz-small" style={{ marginBottom: 12 }}>{countdown}</div>

      <div style={{ display: 'flex', gap: 8 }}>
        {actions.map((a, i) => (
          <button key={i} onClick={a.onClick} disabled={a.disabled}
            className={`gz-btn ${a.ghost ? 'gz-btn--ghost' : ''} gz-btn--sm ${a.attn ? 'gz-attn' : ''}`}
            style={{ flex: 1 }}>
            {a.label}
          </button>
        ))}
      </div>
    </div>
  );
}

function MonthHeader({ children }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '14px 4px 8px' }}>
      <span className="gz-meta">{children}</span>
      <div style={{ flex: 1, height: 1, background: 'var(--gz-rule)' }} />
    </div>
  );
}

function HistoryRow({ id, store, system, dur, cost, status, expanded, setExpanded }) {
  const open = expanded === id;
  const isCanc = status === 'cancelled';
  return (
    <div className="gz-card" style={{ marginBottom: 8, padding: 0 }}>
      <button onClick={() => setExpanded(open ? null : id)}
        style={{ width: '100%', background: 'transparent', border: 0, padding: 16, textAlign: 'left' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12 }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div className="gz-body" style={{ fontWeight: 600, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{store}</div>
            <div className="gz-small" style={{ marginTop: 3 }}>
              {system} · <span className="gz-num">{dur}</span>
            </div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div className="gz-body gz-num" style={{ fontWeight: 700, color: isCanc ? 'var(--gz-fg-3)' : 'var(--gz-fg)', textDecoration: isCanc ? 'line-through' : 'none' }}>
              {cost}
            </div>
            <div className="gz-small" style={{ color: isCanc ? 'var(--gz-err)' : 'var(--gz-fg-3)', marginTop: 2 }}>
              {isCanc ? 'Cancelled' : 'Completed'}
            </div>
          </div>
        </div>
      </button>
      {open && (
        <div style={{ padding: '0 16px 14px' }}>
          <hr className="gz-hr" style={{ margin: '0 0 10px' }} />
          <MetaRow label="Session ID"     value="#SES-20945" />
          <MetaRow label="Payment method" value="UPI" />
          <MetaRow label="Receipt"        value={<span style={{ textDecoration: 'underline' }}>View →</span>} />
        </div>
      )}
    </div>
  );
}

Object.assign(window, { ActivityHubScreen });
