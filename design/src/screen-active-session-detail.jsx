// Screen: Active Session Detail
function ActiveSessionDetailScreen() {
  const [showEvents, setShowEvents] = useState(true);

  return (
    <Phone>
      <TopBar title="Live session" subtitle="GameZone Koramangala" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          {/* Hero timer card */}
          <div style={{
            background: 'var(--gz-card-tint)', borderRadius: 20, padding: 24, textAlign: 'center',
          }}>
            <div className="gz-meta" style={{ color: 'var(--gz-fg-3)' }}>TIME REMAINING</div>
            <div style={{ height: 14 }} />
            <div className="gz-hero">01:22:38</div>
            <div style={{ height: 6 }} />
            <div className="gz-body" style={{ color: 'var(--gz-fg-2)' }}>37:22 elapsed</div>
            <div style={{ height: 18 }} />
            <div className="gz-progress" style={{ height: 6 }}>
              <i style={{ width: '30%', background: 'var(--gz-btn)' }} />
            </div>
            <div style={{ height: 14 }} />
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <span className="gz-small">30% elapsed</span>
              <span className="gz-small gz-num">ID: a3f9b2c1</span>
            </div>
          </div>

          <div style={{ height: 12 }} />

          {/* Session details card */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
              <div style={{
                width: 42, height: 42, borderRadius: 10, background: 'var(--gz-btn)',
                display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', flexShrink: 0,
              }}>
                {React.cloneElement(I.pc, { style: { width: 20, height: 20 } })}
              </div>
              <div style={{ flex: 1 }}>
                <div className="gz-h3">PC Station 03</div>
                <div className="gz-small">GameZone Koramangala</div>
              </div>
              <Tag kind="ok">Active</Tag>
            </div>
          </div>

          <div style={{ height: 12 }} />

          {/* Events log card */}
          <div className="gz-card" style={{ padding: 0, borderRadius: 16 }}>
            <button onClick={() => setShowEvents(s => !s)}
              style={{
                width: '100%', background: 'transparent', border: 0, padding: 16,
                display: 'flex', alignItems: 'center', justifyContent: 'space-between', cursor: 'pointer',
              }}>
              <span style={{ display: 'inline-flex', alignItems: 'center', gap: 10 }}>
                {React.cloneElement(I.list, { style: { width: 18, height: 18 } })}
                <span className="gz-body" style={{ fontWeight: 600 }}>Session events</span>
              </span>
              <span style={{ transform: showEvents ? 'rotate(180deg)' : 'none', transition: 'transform .2s', display: 'inline-flex', color: 'var(--gz-fg-3)' }}>
                {I.chevDn}
              </span>
            </button>
            {showEvents && (
              <div>
                {[
                  { time: '09:41', text: 'Session started' },
                  { time: '—', text: 'Live session in progress' },
                ].map((e, i) => (
                  <div key={i} style={{
                    display: 'flex', gap: 12, padding: '12px 16px',
                    borderTop: '1px solid var(--gz-rule)',
                  }}>
                    <span className="gz-small gz-num" style={{ width: 64, flexShrink: 0 }}>{e.time}</span>
                    <span className="gz-body">{e.text}</span>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div style={{ height: 12 }} />

          {/* Live indicator card */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <LiveDot />
              <span className="gz-body" style={{ fontWeight: 600, color: 'var(--gz-ok)' }}>Session is live</span>
            </div>
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { ActiveSessionDetailScreen });
