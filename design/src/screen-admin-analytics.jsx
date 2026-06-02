// Screen: Admin Analytics Hub
function AdminAnalyticsScreen() {
  const dateFilters = ['Today', '7 Days', 'Custom'];
  const navCards = [
    { icon: I.coin, label: 'Revenue' },
    { icon: I.cal, label: 'Utilization' },
    { icon: I.clock, label: 'Sessions' },
    { icon: I.staff, label: 'Players' },
    { icon: I.pc, label: 'Systems' },
  ];
  const barHeights = [40, 55, 35, 60, 70, 50, 80];
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return (
    <Phone>
      <AdminTopBar title="Analytics" trailing={
        <span style={{ color: 'var(--gz-fg-3)' }}>
          {React.cloneElement(I.up, { style: { width: 20, height: 20 } })}
        </span>
      } />

      {/* Date range chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px 10px', flexShrink: 0 }}>
        {dateFilters.map((f, i) => (
          <AdminChip key={f} label={f} active={i === 0} />
        ))}
      </div>

      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* KPI row — 2×2 grid */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            <AdminKpiCard label="Revenue" value="₹18,420" icon={I.coin} accentColor="var(--gz-ok)" />
            <AdminKpiCard label="Sessions" value="142" icon={I.clock} accentColor="var(--gz-info)" />
            <AdminKpiCard label="Avg. Duration" value="87m" icon={I.cal} accentColor="var(--gz-fg-3)" />
            <AdminKpiCard label="Walk-ins" value="34" icon={I.seat} accentColor="var(--gz-rose)" />
          </div>

          <div style={{ height: 14 }} />

          {/* Quick-nav cards */}
          <div style={{ display: 'flex', gap: 10, overflowX: 'auto', scrollbarWidth: 'none', margin: '0 -16px', padding: '0 16px' }}>
            {navCards.map((c, i) => (
              <div key={i} className="gz-card" style={{ padding: 12, borderRadius: 14, width: 100, flexShrink: 0 }}>
                <span style={{ color: 'var(--gz-fg-3)' }}>
                  {React.cloneElement(c.icon, { style: { width: 18, height: 18 } })}
                </span>
                <div className="gz-small" style={{ marginTop: 6, color: 'var(--gz-fg-2)' }}>{c.label}</div>
              </div>
            ))}
          </div>

          <div style={{ height: 14 }} />

          {/* Revenue chart placeholder */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 12 }}>Today's revenue</div>
            <div style={{ display: 'flex', alignItems: 'flex-end', gap: 8, height: 100 }}>
              {barHeights.map((h, i) => (
                <div key={i} style={{
                  flex: 1, height: h + '%', minHeight: 12,
                  background: i === barHeights.length - 1 ? 'var(--gz-btn)' : 'var(--gz-card-tint)',
                  borderRadius: '4px 4px 0 0',
                }} />
              ))}
            </div>
            <div style={{ display: 'flex', gap: 8, marginTop: 6 }}>
              {days.map(d => (
                <div key={d} style={{ flex: 1, textAlign: 'center' }}>
                  <span className="gz-small" style={{ fontSize: 10 }}>{d}</span>
                </div>
              ))}
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 12 }}>
              <span className="gz-body" style={{ fontWeight: 600 }}>Total: ₹18,420</span>
              <span className="gz-small" style={{ color: 'var(--gz-ok)' }}>vs ₹15,200 yesterday ↑</span>
            </div>
          </div>
        </div>
      </Scroll>

      <AdminBottomNav active="sessions" />
    </Phone>
  );
}
Object.assign(window, { AdminAnalyticsScreen });
