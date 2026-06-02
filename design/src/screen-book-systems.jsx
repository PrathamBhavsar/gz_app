// Screen: Book — Systems Browser
function BookSystemsScreen() {
  const filters = ['All', 'PC', 'PS5', 'Xbox', 'VR', 'Other'];
  const systems = [
    { name: 'PC Station 01', seat: 'Seat 1', icon: I.pc, available: true },
    { name: 'PC Station 02', seat: 'Seat 2', icon: I.pc, available: false },
    { name: 'PS5 Console 01', seat: 'Seat 3', icon: I.ps, available: true },
    { name: 'Xbox Series X', seat: 'Seat 4', icon: I.xbox, available: false },
    { name: 'VR Pod 01', seat: 'Seat 5', icon: I.vr, available: true },
  ];

  return (
    <Phone>
      {/* Header row */}
      <div style={{ padding: '12px 16px 0', display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
        <div className="gz-h1" style={{ flex: 1 }}>Book a System</div>
        <div style={{
          background: 'var(--gz-pill-bg)', borderRadius: 999,
          padding: '6px 12px', fontSize: 13, fontWeight: 600,
          color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', gap: 4,
        }}>
          GameZone Koramangala
          <span style={{ color: 'var(--gz-fg-3)', fontSize: 11 }}>▾</span>
        </div>
      </div>

      {/* Filter chips */}
      <div style={{ display: 'flex', gap: 8, padding: '14px 16px 12px', overflowX: 'auto', scrollbarWidth: 'none', flexShrink: 0 }}>
        {filters.map((f, i) => (
          <button key={f} style={{
            height: 34, padding: '0 14px', border: 0, borderRadius: 'var(--gz-r-chip)',
            background: i === 0 ? 'var(--gz-btn)' : 'var(--gz-card)',
            color: i === 0 ? '#fff' : 'var(--gz-fg-2)',
            fontSize: 13, fontWeight: 600, fontFamily: 'inherit', cursor: 'pointer', flexShrink: 0,
            boxShadow: i === 0 ? 'none' : 'inset 0 0 0 1px var(--gz-rule)',
          }}>{f}</button>
        ))}
      </div>

      <hr className="gz-hr" style={{ flexShrink: 0 }} />

      {/* Systems list */}
      <Scroll pad={false}>
        <div style={{ padding: '12px 16px', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {systems.map((s, i) => (
            <div key={i} className="gz-card" style={{ padding: 14, borderRadius: 16, display: 'flex', alignItems: 'center', gap: 14 }}>
              <div style={{
                width: 40, height: 40, borderRadius: 10, background: 'var(--gz-pill-bg)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: 'var(--gz-fg-3)', flexShrink: 0,
              }}>
                {React.cloneElement(s.icon, { style: { width: 20, height: 20 } })}
              </div>
              <div style={{ flex: 1 }}>
                <div className="gz-h3">{s.name}</div>
                <div className="gz-small">{s.seat}</div>
              </div>
              <Tag kind={s.available ? 'ok' : 'mute'}>{s.available ? 'Available' : 'Booked'}</Tag>
            </div>
          ))}
        </div>
      </Scroll>

      {/* Bottom CTA */}
      <div style={{ background: 'var(--gz-bg)', padding: '8px 16px 16px', flexShrink: 0 }}>
        <Button variant="primary">Check Availability →</Button>
      </div>

      <BottomNav active="book" />
    </Phone>
  );
}
Object.assign(window, { BookSystemsScreen });
