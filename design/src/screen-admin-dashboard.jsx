// Screen: Admin Dashboard (Floor Map)
function AdminDashboardScreen() {
  const chipFilters = ['All', 'PC', 'Console', 'VR', 'Maintenance'];

  const tiles = [
    { name: 'PC Station 01', type: 'PC', status: 'available' },
    { name: 'PC Station 02', type: 'PC', status: 'in_use', user: 'Rahul M.', time: '1h 22m', ending: true },
    { name: 'PC Station 03', type: 'PC', status: 'in_use', user: 'Priya S.', time: '0h 45m' },
    { name: 'PC Station 04', type: 'PC', status: 'in_use', user: 'Amit K.', time: '2h 10m' },
    { name: 'PS5 Console 01', type: 'PS5', status: 'available' },
    { name: 'PS5 Console 02', type: 'PS5', status: 'in_use', user: 'Neha R.', time: '1h 05m' },
    { name: 'Xbox Series X', type: 'Xbox', status: 'in_use', user: 'Suresh V.', time: '0h 30m' },
    { name: 'Xbox Station 02', type: 'Xbox', status: 'maintenance' },
    { name: 'VR Pod 01', type: 'VR', status: 'available' },
    { name: 'VR Pod 02', type: 'VR', status: 'in_use', user: 'Kiran P.', time: '1h 50m' },
    { name: 'PC Station 05', type: 'PC', status: 'available' },
    { name: 'PC Station 06', type: 'PC', status: 'offline' },
  ];

  const statusColors = {
    available: 'var(--gz-ok)',
    in_use: 'var(--gz-info)',
    maintenance: 'var(--gz-warn)',
    offline: 'var(--gz-err)',
  };

  return (
    <Phone>
      {/* AppBar */}
      <div style={{ padding: '10px 16px 0', display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
        <div style={{ flex: 1 }}>
          <div className="gz-h2">Gaming Zone</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 2 }}>
            <span className="gz-small">Operations · Admin</span>
            <span style={{
              background: 'var(--gz-ok-bg)', color: 'var(--gz-ok)',
              borderRadius: 999, padding: '2px 8px', fontSize: 11, fontWeight: 600,
              display: 'inline-flex', alignItems: 'center', gap: 4,
            }}>
              <span style={{ width: 6, height: 6, borderRadius: 999, background: 'var(--gz-ok)' }} />
              Live
            </span>
          </div>
        </div>
        <span style={{ color: 'var(--gz-fg-3)' }}>
          {React.cloneElement(I.bin, { style: { width: 20, height: 20 } })}
        </span>
      </div>

      <div style={{ height: 12 }} />

      {/* KPI ribbon */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px', flexShrink: 0 }}>
        <AdminKpiCard label="Occupancy" value="8/12" icon={I.seat} accentColor="var(--gz-rose)" />
        <AdminKpiCard label="Sessions" value="8" icon={I.clock} accentColor="var(--gz-ok)" />
        <AdminKpiCard label="Available" value="4" icon={I.games} accentColor="var(--gz-fg-3)" />
      </div>

      <div style={{ height: 14 }} />

      {/* Filter chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px', overflowX: 'auto', scrollbarWidth: 'none', flexShrink: 0 }}>
        {chipFilters.map((f, i) => (
          <AdminChip key={f} label={f} active={i === 0} />
        ))}
      </div>

      <div style={{ height: 12 }} />

      {/* Systems grid */}
      <Scroll pad={false}>
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10,
          padding: '0 16px 80px',
        }}>
          {tiles.map((t, i) => {
            const bColor = statusColors[t.status];
            return (
              <div key={i} style={{
                background: 'var(--gz-card)', borderRadius: 14, padding: 12,
                border: `2px solid ${bColor}`,
                display: 'flex', flexDirection: 'column', minHeight: 110,
              }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div className="gz-body" style={{ fontWeight: 600, fontSize: 13, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', flex: 1, marginRight: 6 }}>{t.name}</div>
                  <span style={{ width: 8, height: 8, borderRadius: 999, background: bColor, flexShrink: 0 }} />
                </div>
                <div className="gz-small" style={{ marginTop: 4 }}>{t.type}</div>
                <div style={{ flex: 1 }} />
                {t.status === 'available' && <div className="gz-small" style={{ color: 'var(--gz-ok)' }}>Available</div>}
                {t.status === 'in_use' && (
                  <div>
                    <div className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>{t.user}</div>
                    <div className="gz-small">{t.time}</div>
                    {t.ending && (
                      <span style={{
                        display: 'inline-block', marginTop: 4,
                        background: 'var(--gz-rose-bg)', color: 'var(--gz-rose)',
                        fontSize: 10, fontWeight: 600, borderRadius: 6, padding: '2px 6px',
                      }}>Ending soon</span>
                    )}
                  </div>
                )}
                {t.status === 'maintenance' && (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
                    <span style={{ color: 'var(--gz-fg-3)' }}>{React.cloneElement(I.warnT, { style: { width: 14, height: 14 } })}</span>
                    <span className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>Maintenance</span>
                  </div>
                )}
                {t.status === 'offline' && <div className="gz-small" style={{ color: 'var(--gz-err)' }}>Offline</div>}
              </div>
            );
          })}
        </div>
      </Scroll>

      <AdminBottomNav active="dashboard" />

      {/* FAB */}
      <div style={{
        position: 'absolute', bottom: 90, right: 20,
        width: 56, height: 56, borderRadius: 999,
        background: 'var(--gz-rose)', color: '#fff',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        boxShadow: '0 4px 12px rgba(154,42,31,0.35)',
      }}>
        {React.cloneElement(I.plus, { style: { width: 24, height: 24 } })}
      </div>
    </Phone>
  );
}
Object.assign(window, { AdminDashboardScreen });
