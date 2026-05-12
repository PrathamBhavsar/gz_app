// Screen 7 — Dispute Detail
// Status-tracking screen. Color-coded banner, timeline stepper, withdraw flow.

function DisputeDetailScreen() {
  const [status, setStatus] = useState('review');   // open | review | resolved | withdrawn
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [withdrawn, setWithdrawn] = useState(false);

  // animate timeline dots in sequence on load
  const [dotStage, setDotStage] = useState(0);
  useEffect(() => {
    setDotStage(0);
    const t1 = setTimeout(() => setDotStage(1), 250);
    const t2 = setTimeout(() => setDotStage(2), 600);
    const t3 = setTimeout(() => setDotStage(3), 950);
    return () => { clearTimeout(t1); clearTimeout(t2); clearTimeout(t3); };
  }, [status]);

  const statusMeta = {
    open:      { label: 'Open',         bg: 'var(--gz-warn-bg)',   fg: 'var(--gz-warn)',  icon: I.clock,  resolution: 'Awaiting first review — typically picked up within 24 hours.' },
    review:    { label: 'Under review', bg: 'var(--gz-info-bg)',   fg: 'var(--gz-info)',  icon: I.scale,  resolution: 'Resolution pending — typically 2–3 business days.' },
    resolved:  { label: 'Resolved',     bg: 'var(--gz-ok-bg)',     fg: 'var(--gz-ok)',    icon: I.check,  resolution: 'Full refund of ₹80 issued. May take 2–3 days to reflect.' },
    withdrawn: { label: 'Withdrawn',    bg: 'var(--gz-pill-bg)',   fg: 'var(--gz-fg-2)',  icon: I.x,      resolution: 'You withdrew this dispute. The original charge stands.' },
  };
  const s = statusMeta[status];

  // step states for the stepper
  const stepState = {
    1: 'done',
    2: status === 'open' ? 'pending' : (status === 'withdrawn' ? 'cancelled' : 'done'),
    3: status === 'resolved' ? 'done' : (status === 'withdrawn' ? 'cancelled' : 'pending'),
  };

  return (
    <Phone>
      <TopBar title="Dispute" subtitle="#DIS-0042"
        onBack={() => {}}
        trailing={<IconBtn>{I.info}</IconBtn>} />

      {/* status selector (demo toggle) */}
      <div style={{ padding: '0 16px 12px', flexShrink: 0 }}>
        <div style={{
          display: 'flex', gap: 2, padding: 3,
          background: 'var(--gz-pill-bg)', borderRadius: 10,
        }}>
          {[
            { id: 'open',      l: 'Open' },
            { id: 'review',    l: 'Review' },
            { id: 'resolved',  l: 'Resolved' },
            { id: 'withdrawn', l: 'Withdrawn' },
          ].map(t => (
            <button key={t.id} onClick={() => setStatus(t.id)}
              style={{
                flex: 1, height: 28, border: 0,
                background: status === t.id ? 'var(--gz-card)' : 'transparent',
                color: status === t.id ? 'var(--gz-fg)' : 'var(--gz-fg-3)',
                borderRadius: 7, fontSize: 11, fontWeight: 600,
              }}>{t.l}</button>
          ))}
        </div>
        <div className="gz-small" style={{ textAlign: 'center', marginTop: 6, color: 'var(--gz-fg-4)' }}>
          Demo: change status to preview banner colors
        </div>
      </div>

      <Scroll>
        {/* status banner */}
        <div style={{
          padding: '16px 18px',
          background: s.bg, color: s.fg,
          borderRadius: 18, marginBottom: 14,
          display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <div style={{
            width: 38, height: 38, borderRadius: 999, flexShrink: 0,
            background: 'rgba(255,255,255,0.5)',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          }}>
            {React.cloneElement(s.icon, { style: { width: 20, height: 20 } })}
          </div>
          <div>
            <div className="gz-meta" style={{ color: 'inherit', opacity: 0.7 }}>STATUS</div>
            <div className="gz-h2" style={{ color: 'inherit', marginTop: 3 }}>{s.label}</div>
          </div>
        </div>

        {/* session reference */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 12 }}>DISPUTED SESSION</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14 }}>
            <div className="gz-tile gz-tile--sq" style={{ width: 40, height: 40 }}>
              {React.cloneElement(I.pc, { style: { width: 18, height: 18 } })}
            </div>
            <div>
              <div className="gz-body" style={{ fontWeight: 600 }}>RTX 4090 — Seat 3</div>
              <div className="gz-small" style={{ marginTop: 2 }}>GameZone Koramangala</div>
            </div>
          </div>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
            <span className="gz-chip"><span className="gz-chip__k">WHEN</span>18 Apr · 2h</span>
            <span className="gz-chip"><span className="gz-chip__k">PAID</span>₹160</span>
            <span className="gz-chip"><span className="gz-chip__k">VIA</span>UPI</span>
          </div>
        </div>

        {/* disputed amount */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 12 }}>AMOUNT IN DISPUTE</div>
          <MetaRow label="Original charge"  value="₹160" />
          <MetaRow label="Amount disputed"  value={<span style={{ color: 'var(--gz-err)' }}>₹80</span>} />
          <hr className="gz-hr" style={{ margin: '8px 0' }} />
          <div className="gz-body-r" style={{ fontSize: 13 }}>
            Reason: <span style={{ color: 'var(--gz-fg)', fontWeight: 500 }}>Session ended 45 minutes early, full amount charged.</span>
          </div>
        </div>

        {/* player quote */}
        <div className="gz-card" style={{ marginBottom: 12, padding: 18 }}>
          <div className="gz-meta" style={{ marginBottom: 10 }}>YOUR DESCRIPTION</div>
          <div style={{
            padding: '12px 14px',
            background: 'var(--gz-pill-bg)',
            borderRadius: 12,
            borderLeft: '3px solid var(--gz-fg)',
            fontSize: 13.5, lineHeight: 1.45,
            color: 'var(--gz-fg)',
            fontStyle: 'italic',
          }}>
            "The system crashed at 5:23 PM and staff could not restart it. I was asked to leave. Full 2-hour charge was still applied."
          </div>
        </div>

        {/* resolution placeholder */}
        <div className="gz-card" style={{ marginBottom: 12, display: 'flex', gap: 12, alignItems: 'flex-start' }}>
          <div className="gz-tile" style={{ background: s.bg, color: s.fg, flexShrink: 0 }}>
            {React.cloneElement(s.icon, { style: { width: 18, height: 18 } })}
          </div>
          <div>
            <div className="gz-h3" style={{ marginBottom: 4 }}>Resolution</div>
            <div className="gz-body-r" style={{ fontSize: 13 }}>{s.resolution}</div>
          </div>
        </div>

        {/* timeline */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 14 }}>TIMELINE</div>
          <TimelineStep n={1} state={dotStage >= 1 ? stepState[1] : 'pending'} title="Dispute filed"  date="18 Apr · 6:42 PM" />
          <TimelineStep n={2} state={dotStage >= 2 ? stepState[2] : 'pending'} title="Under review"   date={status === 'open' ? 'Pending' : '19 Apr · 9:00 AM'} />
          <TimelineStep n={3} state={dotStage >= 3 ? stepState[3] : 'pending'} title="Resolution"
            date={status === 'resolved' ? '21 Apr · 2:10 PM' : (status === 'withdrawn' ? 'Cancelled' : 'Pending')}
            last />
        </div>

        {/* withdraw */}
        {status !== 'withdrawn' && status !== 'resolved' && (
          <div style={{ padding: '8px 4px 4px', textAlign: 'center' }}>
            <button onClick={() => setConfirmOpen(true)}
              className="gz-btn gz-btn--danger-outline gz-btn--sm"
              style={{ width: 'auto', display: 'inline-flex', padding: '0 18px' }}>
              Withdraw dispute
            </button>
          </div>
        )}
        {withdrawn && (
          <div style={{
            marginTop: 12, padding: '10px 12px',
            background: 'var(--gz-ok-bg)', color: 'var(--gz-ok)',
            borderRadius: 12, fontSize: 12, fontWeight: 600,
            textAlign: 'center',
          }}>
            Dispute withdrawn successfully
          </div>
        )}
      </Scroll>

      {/* confirm dialog */}
      {confirmOpen && (
        <div className="gz-sheet-overlay" onClick={() => setConfirmOpen(false)}
          style={{ alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <div onClick={e => e.stopPropagation()} style={{
            background: 'var(--gz-card)', borderRadius: 22, padding: 22,
            maxWidth: 320, width: '100%',
            animation: 'gz-slide-up 0.18s cubic-bezier(.2,.7,.3,1)',
          }}>
            <div style={{
              width: 40, height: 40, borderRadius: 999,
              background: 'var(--gz-err-bg)', color: 'var(--gz-err)',
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
              marginBottom: 14,
            }}>{React.cloneElement(I.warnT, { style: { width: 20, height: 20 } })}</div>
            <div className="gz-h1" style={{ marginBottom: 6 }}>Withdraw this dispute?</div>
            <div className="gz-body-r" style={{ marginBottom: 18 }}>
              This action can't be undone. The original ₹160 charge will stand.
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <button className="gz-btn gz-btn--ghost" onClick={() => setConfirmOpen(false)}>
                Keep dispute
              </button>
              <button className="gz-btn" onClick={() => { setConfirmOpen(false); setStatus('withdrawn'); setWithdrawn(true); setTimeout(() => setWithdrawn(false), 2200); }}
                style={{ background: 'var(--gz-err)' }}>
                Withdraw
              </button>
            </div>
          </div>
        </div>
      )}
    </Phone>
  );
}

function TimelineStep({ n, state, title, date, last }) {
  const styles = {
    done:      { ring: 'var(--gz-fg)',    fill: 'var(--gz-fg)',  fg: '#fff',           line: 'var(--gz-fg)' },
    pending:   { ring: 'var(--gz-rule)',  fill: 'var(--gz-card)', fg: 'var(--gz-fg-3)', line: 'var(--gz-rule)' },
    cancelled: { ring: 'var(--gz-rule)',  fill: 'var(--gz-pill-bg)', fg: 'var(--gz-fg-4)', line: 'var(--gz-rule)' },
  }[state];

  return (
    <div style={{ display: 'flex', gap: 14, position: 'relative', minHeight: last ? 32 : 56 }}>
      <div style={{ width: 24, position: 'relative', flexShrink: 0 }}>
        <div style={{
          width: 24, height: 24, borderRadius: 999,
          background: styles.fill, color: styles.fg,
          boxShadow: `inset 0 0 0 2px ${styles.ring}`,
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 12, fontWeight: 700, fontFamily: 'var(--gz-mono)',
          transition: 'background .3s, color .3s, box-shadow .3s',
        }}>
          {state === 'done' ? '✓' : (state === 'cancelled' ? '×' : n)}
        </div>
        {!last && (
          <div style={{
            position: 'absolute', top: 28, left: 11, width: 2, bottom: -6,
            background: styles.line, transition: 'background .3s',
          }} />
        )}
      </div>
      <div style={{ paddingBottom: 12, flex: 1 }}>
        <div className="gz-body" style={{ fontWeight: 600,
          color: state === 'cancelled' ? 'var(--gz-fg-3)' : 'var(--gz-fg)' }}>
          {title}
        </div>
        <div className="gz-small gz-num" style={{ marginTop: 2,
          textDecoration: state === 'cancelled' ? 'line-through' : 'none' }}>
          {date}
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { DisputeDetailScreen });
