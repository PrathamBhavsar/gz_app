// Screen 14 — Campaign Detail
// Hero banner, eligibility, how-it-works, share sheet, reminder toggle, book transition.

function CampaignDetailScreen() {
  const [reminderSet, setReminderSet] = useState(false);
  const [showShare, setShowShare]     = useState(false);
  const [bookNav, setBookNav]         = useState(false);

  const shareIc = (
    <svg viewBox="0 0 24 24" className="gz-ic">
      <circle cx="18" cy="5" r="2.5"/><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="19" r="2.5"/>
      <path d="M8.5 10.5l7-4M8.5 13.5l7 4"/>
    </svg>
  );

  const eligibility = [
    { ok: true,  text: 'Available to all members' },
    { ok: true,  text: 'No minimum spend' },
    { ok: false, text: 'Cannot combine with other discounts' },
    { ok: false, text: 'Excludes VR systems' },
  ];

  const steps = [
    'Book any system',
    'Select this campaign at checkout',
    'Discount applied automatically',
  ];

  return (
    <Phone>
      {/* header */}
      <div style={{ padding: '8px 16px 12px', display: 'grid',
        gridTemplateColumns: '40px 1fr 40px', alignItems: 'center', flexShrink: 0 }}>
        <IconBtn>{I.back}</IconBtn>
        <div className="gz-h2" style={{ textAlign: 'center' }}>Happy Hour</div>
        <IconBtn onClick={() => setShowShare(true)}>{shareIc}</IconBtn>
      </div>

      <Scroll>
        {/* hero banner */}
        <div style={{
          padding: '26px 22px 22px',
          background: 'linear-gradient(140deg, oklch(0.38 0.16 280) 0%, oklch(0.30 0.18 310) 100%)',
          borderRadius: 22, marginBottom: 14, position: 'relative', overflow: 'hidden',
        }}>
          <div style={{ position: 'absolute', top: -28, right: -28, width: 130, height: 130,
            borderRadius: 999, background: 'rgba(255,255,255,0.06)' }} />
          <div style={{ position: 'absolute', bottom: -20, right: 40, width: 70, height: 70,
            borderRadius: 999, background: 'rgba(255,255,255,0.05)' }} />
          <div style={{ marginBottom: 12 }}>
            <Tag kind="purple">Discount</Tag>
          </div>
          <div className="gz-title" style={{ color: '#fff', marginBottom: 4 }}>Happy Hour</div>
          <div className="gz-h2" style={{ color: 'rgba(255,255,255,0.75)', fontWeight: 500 }}>
            30% off all sessions
          </div>
        </div>

        {/* benefit block — mint hero */}
        <div className="gz-card gz-card--tint" style={{ padding: 18, marginBottom: 12 }}>
          <div className="gz-meta" style={{ color: 'var(--gz-fg-2)', marginBottom: 10 }}>WHAT YOU GET</div>
          <div className="gz-h1" style={{ marginBottom: 12 }}>Save 30% on every booking</div>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            <span className="gz-chip"><span className="gz-chip__k">DAYS</span>Mon–Fri</span>
            <span className="gz-chip"><span className="gz-chip__k">TIME</span>10:00–14:00</span>
          </div>
        </div>

        {/* validity + time restriction */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '6px 0 14px',
            borderBottom: '1px solid var(--gz-rule)' }}>
            <div className="gz-tile" style={{ width: 36, height: 36,
              background: 'var(--gz-info-bg)', color: 'var(--gz-info)', flexShrink: 0 }}>
              {React.cloneElement(I.cal, { style: { width: 16, height: 16 } })}
            </div>
            <div>
              <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 2 }}>VALID UNTIL</div>
              <div className="gz-body" style={{ fontWeight: 600 }}>30 April 2025</div>
            </div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, paddingTop: 14 }}>
            <div className="gz-tile" style={{ width: 36, height: 36,
              background: 'var(--gz-warn-bg)', color: 'var(--gz-warn)', flexShrink: 0 }}>
              {React.cloneElement(I.clock, { style: { width: 16, height: 16 } })}
            </div>
            <div>
              <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 2 }}>RESTRICTION</div>
              <div className="gz-body" style={{ fontWeight: 600, fontSize: 13 }}>
                Only applies during Happy Hour window
              </div>
            </div>
          </div>
        </div>

        {/* eligibility */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 12 }}>ELIGIBILITY</div>
          {eligibility.map((e, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10,
              padding: '9px 0', borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)' }}>
              <div style={{
                width: 22, height: 22, borderRadius: 999, flexShrink: 0,
                background: e.ok ? 'var(--gz-ok-bg)' : 'var(--gz-err-bg)',
                color: e.ok ? 'var(--gz-ok)' : 'var(--gz-err)',
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
              }}>
                {e.ok
                  ? <svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 13, height: 13, strokeWidth: 2.8 }}><path d="M5 12l5 5L20 7"/></svg>
                  : <svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 13, height: 13, strokeWidth: 2.8 }}><path d="M6 6l12 12M18 6L6 18"/></svg>
                }
              </div>
              <span className="gz-body" style={{ fontSize: 13, fontWeight: 600 }}>{e.text}</span>
            </div>
          ))}
          <div style={{ marginTop: 12, paddingTop: 12, borderTop: '1px solid var(--gz-rule)' }}>
            <span className="gz-small">
              Used <span className="gz-num" style={{ fontWeight: 700, color: 'var(--gz-fg)' }}>847 times</span>
              {' · '}Unlimited redemptions available
            </span>
          </div>
        </div>

        {/* how it works */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 14 }}>HOW IT WORKS</div>
          {steps.map((s, i) => (
            <div key={i} style={{ display: 'flex', gap: 14, padding: '8px 0', alignItems: 'center',
              borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)' }}>
              <div style={{
                width: 28, height: 28, borderRadius: 999, flexShrink: 0,
                background: 'var(--gz-fg)', color: '#fff',
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: 'var(--gz-mono)', fontSize: 13, fontWeight: 700,
              }}>{i + 1}</div>
              <span className="gz-body" style={{ fontSize: 13 }}>{s}</span>
            </div>
          ))}
        </div>

        {/* my redemptions */}
        <div className="gz-card gz-card--inset" style={{ display: 'flex',
          justifyContent: 'space-between', alignItems: 'center', marginBottom: 24 }}>
          <div>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 4 }}>MY USAGE</div>
            <div className="gz-body" style={{ fontWeight: 700 }}>Used 3 times</div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 4 }}>LAST USED</div>
            <div className="gz-body gz-num" style={{ fontWeight: 600 }}>12 Apr</div>
          </div>
        </div>
      </Scroll>

      {/* sticky CTAs */}
      <div style={{ padding: '12px 16px 22px', flexShrink: 0, background: 'var(--gz-bg)',
        display: 'flex', flexDirection: 'column', gap: 8,
        boxShadow: '0 -8px 20px -8px rgba(0,0,0,0.05)' }}>
        <button className="gz-btn" onClick={() => setBookNav(true)}>
          Use when booking
        </button>
        <button className="gz-btn gz-btn--ghost" style={{ height: 44, fontSize: 13 }}
          onClick={() => setReminderSet(r => !r)}>
          {reminderSet
            ? <>{React.cloneElement(I.check, { style: { width: 16, height: 16, color: 'var(--gz-ok)' } })}&nbsp; Reminder set</>
            : 'Add to reminders'}
        </button>
      </div>

      {/* share sheet */}
      {showShare && (
        <div className="gz-sheet-overlay" onClick={() => setShowShare(false)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 18 }}>Share campaign</div>
            {['Copy link', 'Share via WhatsApp', 'Share via Messages', 'More options…'].map((opt, i) => (
              <button key={i} onClick={() => setShowShare(false)} style={{
                width: '100%', padding: '15px 0', background: 'transparent', border: 0,
                borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)',
                textAlign: 'left', fontSize: 15, fontWeight: 600, color: 'var(--gz-fg)', cursor: 'pointer',
              }}>{opt}</button>
            ))}
          </div>
        </div>
      )}

      {/* book nav overlay */}
      {bookNav && (
        <div onClick={() => setBookNav(false)} style={{
          position: 'absolute', inset: 0, background: 'rgba(10,10,10,0.45)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          zIndex: 80, animation: 'gz-fade 0.15s ease-out',
        }}>
          <div style={{
            background: 'var(--gz-card)', borderRadius: 18, padding: '18px 22px',
            display: 'flex', alignItems: 'center', gap: 14,
            animation: 'gz-slide-up 0.18s cubic-bezier(.2,.7,.3,1)',
          }}>
            <span className="gz-dot-pulse" />
            <div>
              <div className="gz-meta" style={{ marginBottom: 2 }}>SWITCHING TO</div>
              <div className="gz-body" style={{ fontWeight: 700 }}>Book → Apply campaign</div>
            </div>
          </div>
        </div>
      )}
    </Phone>
  );
}

Object.assign(window, { CampaignDetailScreen });
