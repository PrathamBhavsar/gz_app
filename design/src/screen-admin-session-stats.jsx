// Screen: Admin Session Statistics
function AdminSessionStatsScreen() {
  const recentSessions = [
    { name: 'Rahul M.', system: 'PC Station 01', dur: '2h 10m', tag: 'ok', tagLabel: 'Completed' },
    { name: 'Priya S.', system: 'PS5 Console', dur: '1h 30m', tag: 'ok', tagLabel: 'Completed' },
    { name: 'Amit K.', system: 'Xbox Series X', dur: '0h 45m', tag: 'warn', tagLabel: 'Early end' },
    { name: 'Neha R.', system: 'VR Pod 01', dur: '2h 00m', tag: 'ok', tagLabel: 'Completed' },
  ];

  return (
    <Phone>
      <AdminTopBar title="Session Stats" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* 4 stat cards in 2×2 grid */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            <AdminKpiCard label="Avg Duration" value="87 min" icon={I.clock} accentColor="var(--gz-info)" />
            <AdminKpiCard label="Completion" value="94%" icon={I.check} accentColor="var(--gz-ok)" />
            <AdminKpiCard label="Walk-ins" value="34" icon={I.seat} accentColor="var(--gz-rose)" />
            <AdminKpiCard label="Bookings" value="108" icon={I.cal} accentColor="var(--gz-fg-3)" />
          </div>

          <div style={{ height: 14 }} />

          {/* Session type breakdown */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Session types</div>
            {[
              { label: 'Walk-in', pct: 24, color: 'var(--gz-rose)' },
              { label: 'Booking', pct: 76, color: 'var(--gz-info)' },
            ].map((t, i) => (
              <div key={i} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: i === 0 ? 8 : 0 }}>
                <span className="gz-body">{t.label}</span>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <div style={{ width: 100, height: 6, borderRadius: 999, background: 'var(--gz-rule)', overflow: 'hidden' }}>
                    <div style={{ width: t.pct + '%', height: '100%', borderRadius: 999, background: t.color }} />
                  </div>
                  <span className="gz-small gz-num">{t.pct}%</span>
                </div>
              </div>
            ))}
          </div>

          <div style={{ height: 12 }} />

          {/* Recent sessions list */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 12 }}>Recent sessions</div>
            {recentSessions.map((s, i) => (
              <div key={i} style={{
                display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                padding: '10px 0',
                borderTop: i > 0 ? '1px solid var(--gz-rule)' : 'none',
              }}>
                <div style={{ flex: 1 }}>
                  <div className="gz-body" style={{ fontSize: 13 }}>{s.name} · {s.system}</div>
                  <div className="gz-small">{s.dur}</div>
                </div>
                <Tag kind={s.tag}>{s.tagLabel}</Tag>
              </div>
            ))}
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminSessionStatsScreen });
