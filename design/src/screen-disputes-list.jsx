// Screen 25 — Disputes List
// Player's full dispute history. Status-tracking list. Entry point to detail and creation.

function DisputesListScreen() {
  const [storeFilter, setStoreFilter] = useState('all');
  const [statusFilter, setStatusFilter] = useState('all');
  const [showStores, setShowStores] = useState(false);

  const stores = [
    { id: 'all', name: 'All stores' },
    { id: 'kor', name: 'GameZone Koramangala' },
    { id: 'mgr', name: 'GameZone MG Road' },
    { id: 'wf', name: 'GameZone Whitefield' },
  ];

  const allDisputes = [
    {
      id: 1, status: 'open', statusLabel: 'Open',
      sessionRef: 'SES-20901', store: 'GameZone Koramangala', date: '15 Apr',
      disputed: '₹80 of ₹160 charged',
      reason: 'Session ended 45 min early but full amount...',
      filed: '3 days ago',
    },
    {
      id: 2, status: 'review', statusLabel: 'Under Review',
      sessionRef: 'SES-20748', store: 'GameZone MG Road', date: '8 Apr',
      disputed: '₹90 full session charge',
      reason: 'System was completely unusable for first 20...',
      filed: '10 days ago',
    },
    {
      id: 3, status: 'resolved', statusLabel: 'Resolved — Refunded',
      sessionRef: 'SES-20512', store: 'GameZone Koramangala', date: '22 Mar',
      disputed: '₹160',
      resolution: 'Full refund issued — ₹160 credited back',
      filed: '20 days ago',
    },
    {
      id: 4, status: 'withdrawn', statusLabel: 'Withdrawn',
      sessionRef: 'SES-20301', store: 'GameZone Whitefield', date: '10 Mar',
      disputed: '₹120',
      reason: 'Withdrawn by you · 25 days ago',
      filed: '25 days ago',
    },
  ];

  const statusOptions = ['all', 'open', 'review', 'resolved', 'withdrawn'];
  const storeFilterObj = stores.find(s => s.id === storeFilter);

  let filteredDisputes = allDisputes;
  if (storeFilter !== 'all') {
    filteredDisputes = filteredDisputes.filter(d => {
      const storeId = d.store.includes('Koramangala') ? 'kor' : d.store.includes('MG Road') ? 'mgr' : 'wf';
      return storeId === storeFilter;
    });
  }
  if (statusFilter !== 'all') {
    filteredDisputes = filteredDisputes.filter(d => d.status === statusFilter);
  }

  const statusBgColor = (status) => {
    switch(status) {
      case 'open': return 'var(--gz-warn-bg)';
      case 'review': return 'var(--gz-info-bg)';
      case 'resolved': return 'var(--gz-ok-bg)';
      case 'withdrawn': return 'var(--gz-pill-bg)';
      default: return 'var(--gz-card)';
    }
  };

  const statusBorderColor = (status) => {
    switch(status) {
      case 'open': return 'var(--gz-warn)';
      case 'review': return 'var(--gz-info)';
      case 'resolved': return 'var(--gz-ok)';
      case 'withdrawn': return 'var(--gz-fg-3)';
      default: return 'transparent';
    }
  };

  const statusTextColor = (status) => {
    switch(status) {
      case 'open': return 'var(--gz-warn)';
      case 'review': return 'var(--gz-info)';
      case 'resolved': return 'var(--gz-ok)';
      case 'withdrawn': return 'var(--gz-fg-3)';
      default: return 'var(--gz-fg)';
    }
  };

  return (
    <Phone>
      <TopBar
        title="My disputes"
        onBack={() => {}}
        trailing={
          <button onClick={() => {}}
            style={{
              height: 36, padding: '0 12px',
              background: 'var(--gz-btn)',
              color: 'var(--gz-btn-fg)',
              border: 0, borderRadius: 10,
              fontSize: 12, fontWeight: 600,
              display: 'inline-flex', alignItems: 'center', gap: 6,
            }}>
            {React.cloneElement(I.plus, { style: { width: 14, height: 14 } })}
            File new
          </button>
        }
      />

      <Scroll>
        {/* summary strip */}
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12,
          padding: '4px 0 16px',
        }}>
          {[
            { label: '3 total', val: '3' },
            { label: '1 open', val: '1' },
            { label: '1 resolved', val: '1' },
            { label: '1 withdrawn', val: '1' },
          ].map((s, i) => (
            <div key={i} style={{ textAlign: 'center' }}>
              <div className="gz-num gz-h3" style={{ color: 'var(--gz-fg)' }}>{s.val}</div>
              <div className="gz-small" style={{ marginTop: 2 }}>{s.label}</div>
            </div>
          ))}
        </div>

        {/* store filter */}
        <button onClick={() => setShowStores(true)}
          style={{
            display: 'inline-flex', alignItems: 'center', gap: 8,
            padding: '8px 14px',
            background: 'var(--gz-pill-bg)',
            border: 0, borderRadius: 999,
            margin: '0 0 16px',
          }}>
          <span className="gz-body" style={{ fontWeight: 600 }}>{storeFilterObj.name}</span>
          {React.cloneElement(I.chevDn, { style: { width: 14, height: 14, color: 'var(--gz-fg-3)' } })}
        </button>

        {/* status filter tabs */}
        <div style={{ display: 'flex', gap: 8, marginBottom: 16, overflowX: 'auto', paddingBottom: 4 }}>
          {statusOptions.map(status => {
            const labels = { all: 'All', open: 'Open', review: 'Review', resolved: 'Resolved', withdrawn: 'Withdrawn' };
            return (
              <button key={status} onClick={() => setStatusFilter(status)}
                style={{
                  padding: '8px 14px',
                  background: statusFilter === status ? 'var(--gz-fg)' : 'var(--gz-pill-bg)',
                  color: statusFilter === status ? '#fff' : 'var(--gz-fg)',
                  border: 0, borderRadius: 999,
                  fontSize: 13, fontWeight: 600, flexShrink: 0,
                  cursor: 'pointer',
                }}>
                {labels[status]}
              </button>
            );
          })}
        </div>

        {/* disputes list */}
        {filteredDisputes.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '40px 20px' }}>
            <div style={{ fontSize: 32, marginBottom: 12 }}>🛡️</div>
            <div className="gz-h2" style={{ marginBottom: 8 }}>No disputes filed</div>
            <button style={{
              background: 'transparent', border: 0,
              color: 'var(--gz-fg)', fontSize: 14, fontWeight: 600,
              textDecoration: 'underline', padding: 0,
            }}>
              File a dispute →
            </button>
          </div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 12 }}>
            {filteredDisputes.map(d => (
              <button key={d.id} onClick={() => {}}
                style={{
                  background: 'var(--gz-card)',
                  border: 0, borderRadius: 18,
                  padding: 0,
                  textAlign: 'left',
                  overflow: 'hidden',
                  opacity: d.status === 'withdrawn' ? 0.65 : 1,
                  transform: d.status === 'withdrawn' ? 'scale(0.98)' : 'scale(1)',
                  transformOrigin: 'center',
                }}>
                <div style={{
                  display: 'flex', alignItems: 'stretch',
                  minHeight: 140,
                }}>
                  {/* left status border */}
                  <div style={{
                    width: 4, flexShrink: 0,
                    background: statusBorderColor(d.status),
                  }} />

                  {/* content */}
                  <div style={{ flex: 1, padding: '16px', display: 'flex', flexDirection: 'column', gap: 10 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <span className="gz-body" style={{
                          fontWeight: 600,
                          color: statusTextColor(d.status),
                          fontSize: 12, textTransform: 'uppercase', letterSpacing: '0.05em',
                        }}>
                          {d.statusLabel}
                        </span>
                      </div>
                      <span className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>View →</span>
                    </div>

                    <div>
                      <div className="gz-body" style={{ fontWeight: 600, marginBottom: 2 }}>
                        {d.sessionRef} · {d.store} · {d.date}
                      </div>
                      <div className="gz-body" style={{ color: 'var(--gz-fg-2)', fontSize: 13 }}>
                        Disputed: {d.disputed}
                      </div>
                    </div>

                    <div className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>
                      {d.resolution ? (
                        <span style={{ color: 'var(--gz-ok)' }}>{d.resolution}</span>
                      ) : d.reason ? (
                        d.reason
                      ) : null}
                    </div>

                    <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginTop: 'auto' }}>
                      {d.resolution ? `Resolved ${d.filed.replace('ago', '')}` : `Filed ${d.filed}`}
                    </div>
                  </div>
                </div>
              </button>
            ))}
          </div>
        )}
      </Scroll>

      <BottomNav active="wallet" />

      {/* store selector overlay */}
      {showStores && (
        <div className="gz-sheet-overlay" onClick={() => setShowStores(false)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 4 }}>Filter by store</div>
            {stores.map(s => (
              <button key={s.id}
                onClick={() => { setStoreFilter(s.id); setShowStores(false); }}
                style={{
                  width: '100%', padding: 14,
                  background: s.id === storeFilter ? 'var(--gz-card-tint)' : 'var(--gz-pill-bg)',
                  border: 0, borderRadius: 14, marginBottom: 8,
                  display: 'flex', alignItems: 'center', justifyContent: 'space-between', textAlign: 'left',
                  cursor: 'pointer',
                }}>
                <div className="gz-body" style={{ fontWeight: 600 }}>{s.name}</div>
                {s.id === storeFilter && (
                  <svg viewBox="0 0 24 24" className="gz-ic" style={{ color: 'var(--gz-fg)' }}><path d="M5 12l5 5L20 7"/></svg>
                )}
              </button>
            ))}
          </div>
        </div>
      )}
    </Phone>
  );
}

Object.assign(window, { DisputesListScreen });
