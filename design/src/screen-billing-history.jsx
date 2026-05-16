// Screen 23: Billing History
// Financial record screen with grouped months, expandable rows, store filter

const { useState } = React;

function BillingHistoryScreen() {
  const [expandedRow, setExpandedRow] = useState(null);
  const [collapsedMonths, setCollapsedMonths] = useState(new Set(['feb-2025']));
  const [storeFilter, setStoreFilter] = useState('all');
  const [showStoreFilter, setShowStoreFilter] = useState(false);

  const stores = [
    { id: 'all', name: 'All stores' },
    { id: 'koraman', name: 'GameZone Koramangala' },
    { id: 'mgroad', name: 'GameZone MG Road' },
    { id: 'whitefield', name: 'GameZone Whitefield' },
  ];

  const billingData = [
    {
      month: 'April 2025',
      monthKey: 'apr-2025',
      total: '₹320',
      rows: [
        { id: 1, store: 'GameZone Koramangala', system: 'RTX 4090', duration: '2 hrs', amount: '₹102', payment: 'UPI', status: 'Completed', sessionId: '#SES-20948', date: '18 Apr 2025, 4:00 PM – 6:02 PM', actualDuration: '2 hrs 2 min', breakdown: [{ label: 'Base', amount: '₹160' }, { label: 'Campaign', amount: '−₹48' }, { label: 'Credits', amount: '−₹30' }, { label: 'Surcharge', amount: '+₹20' }], creditsEarned: '+102 credits' },
        { id: 2, store: 'GameZone MG Road', system: 'PS5', duration: '1 hr', amount: '₹90', payment: 'Cash', status: 'Completed' },
        { id: 3, store: 'GameZone Koramangala', system: 'VR Rig', duration: '1 hr', amount: '₹128', payment: 'Credits', status: 'Completed' },
      ]
    },
    {
      month: 'March 2025',
      monthKey: 'mar-2025',
      total: '₹480',
      rows: [
        { id: 4, store: 'GameZone Koramangala', system: 'RTX 4090', duration: '3 hrs', amount: '₹240', payment: 'Card', status: 'Completed' },
        { id: 5, store: 'GameZone MG Road', system: 'Xbox', duration: '2 hrs', amount: '₹140', payment: 'UPI', status: 'Completed' },
        { id: 6, store: 'GameZone Whitefield', system: 'PC', duration: '2 hrs', amount: '₹0', payment: 'Cash', status: 'Cancelled' },
      ]
    },
    {
      month: 'February 2025',
      monthKey: 'feb-2025',
      total: '₹400',
      rows: [
        { id: 7, store: 'GameZone Koramangala', system: 'RTX 4090', duration: '2 hrs', amount: '₹150', payment: 'UPI', status: 'Completed' },
        { id: 8, store: 'GameZone MG Road', system: 'PS5', duration: '1.5 hrs', amount: '₹110', payment: 'Card', status: 'Completed' },
        { id: 9, store: 'GameZone Whitefield', system: 'Xbox', duration: '1 hr', amount: '₹140', payment: 'Cash', status: 'Completed' },
      ]
    }
  ];

  const toggleMonth = (monthKey) => {
    const newCollapsed = new Set(collapsedMonths);
    if (newCollapsed.has(monthKey)) {
      newCollapsed.delete(monthKey);
    } else {
      newCollapsed.add(monthKey);
    }
    setCollapsedMonths(newCollapsed);
  };

  const isMonthCollapsed = (monthKey) => collapsedMonths.has(monthKey);

  return (
    <Phone>
      <TopBar title="Billing history" onBack={() => {}} />

      <Scroll>
        {/* Store filter */}
        <div style={{ position: 'relative', marginBottom: 16 }}>
          <button
            onClick={() => setShowStoreFilter(!showStoreFilter)}
            style={{
              width: '100%',
              background: 'var(--gz-pill-bg)',
              border: `1px solid var(--gz-rule)`,
              padding: '10px 14px',
              borderRadius: 'var(--gz-r-chip)',
              fontSize: 13,
              fontWeight: 600,
              color: 'var(--gz-fg)',
              cursor: 'pointer',
              fontFamily: 'inherit',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
            }}
          >
            <span>{stores.find(s => s.id === storeFilter)?.name}</span>
            {I.chevDn}
          </button>
          {showStoreFilter && (
            <div style={{
              position: 'absolute',
              top: '100%',
              left: 0,
              right: 0,
              background: 'var(--gz-card)',
              border: `1px solid var(--gz-rule)`,
              borderRadius: 'var(--gz-r-inner)',
              marginTop: 4,
              zIndex: 10,
              boxShadow: '0 4px 12px rgba(0,0,0,0.08)',
            }}>
              {stores.map(store => (
                <button
                  key={store.id}
                  onClick={() => {
                    setStoreFilter(store.id);
                    setShowStoreFilter(false);
                  }}
                  style={{
                    width: '100%',
                    background: 'transparent',
                    border: 0,
                    padding: '12px 16px',
                    textAlign: 'left',
                    color: storeFilter === store.id ? 'var(--gz-fg)' : 'var(--gz-fg-2)',
                    fontWeight: storeFilter === store.id ? 600 : 500,
                    cursor: 'pointer',
                    fontFamily: 'inherit',
                    fontSize: 14,
                    borderBottom: store.id !== stores[stores.length - 1].id ? `1px solid var(--gz-divider)` : 'none',
                  }}
                >
                  {store.name}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Summary strip */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr 1fr',
          gap: 12,
          marginBottom: 20,
          textAlign: 'center',
        }}>
          <div style={{ background: 'var(--gz-card)', padding: '12px', borderRadius: 'var(--gz-r-inner)' }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 4 }}>Total spent</div>
            <div className="gz-body" style={{ fontWeight: 700, color: 'var(--gz-fg)' }}>₹1,840</div>
          </div>
          <div style={{ background: 'var(--gz-card)', padding: '12px', borderRadius: 'var(--gz-r-inner)' }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 4 }}>Sessions</div>
            <div className="gz-body" style={{ fontWeight: 700, color: 'var(--gz-fg)' }}>12</div>
          </div>
          <div style={{ background: 'var(--gz-card)', padding: '12px', borderRadius: 'var(--gz-r-inner)' }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 4 }}>Stores</div>
            <div className="gz-body" style={{ fontWeight: 700, color: 'var(--gz-fg)' }}>3</div>
          </div>
        </div>

        {/* Month groups */}
        {billingData.map(monthGroup => (
          <div key={monthGroup.monthKey} style={{ marginBottom: 16 }}>
            {/* Month header */}
            <button
              onClick={() => toggleMonth(monthGroup.monthKey)}
              style={{
                width: '100%',
                background: 'transparent',
                border: 0,
                padding: '12px 0',
                marginBottom: 8,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                cursor: 'pointer',
                fontSize: 16,
                fontWeight: 700,
                color: 'var(--gz-fg)',
                fontFamily: 'inherit',
              }}
            >
              <span>{monthGroup.month}</span>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <span style={{ fontSize: 14, fontWeight: 600, color: 'var(--gz-fg-2)' }}>{monthGroup.total}</span>
                <span style={{
                  transform: isMonthCollapsed(monthGroup.monthKey) ? 'rotate(0deg)' : 'rotate(180deg)',
                  transition: 'transform 0.2s',
                  display: 'inline-flex',
                  color: 'var(--gz-fg-3)',
                }}>
                  {I.chevDn}
                </span>
              </div>
            </button>

            {!isMonthCollapsed(monthGroup.monthKey) ? (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
                {monthGroup.rows.map(row => (
                  <div key={row.id}>
                    {/* Row header (collapsed state) */}
                    <button
                      onClick={() => setExpandedRow(expandedRow === row.id ? null : row.id)}
                      style={{
                        width: '100%',
                        background: row.status === 'Cancelled' ? 'rgba(0,0,0,0.02)' : 'var(--gz-card)',
                        border: `1px solid var(--gz-rule)`,
                        padding: '12px 14px',
                        borderRadius: 'var(--gz-r-inner)',
                        textAlign: 'left',
                        cursor: 'pointer',
                        fontFamily: 'inherit',
                        color: 'var(--gz-fg)',
                        opacity: row.status === 'Cancelled' ? 0.6 : 1,
                      }}
                    >
                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 6 }}>
                        <span className="gz-body" style={{ fontWeight: 600, flex: 1 }}>{row.store}</span>
                        <span className="gz-body" style={{ fontWeight: 700, color: 'var(--gz-fg)' }}>
                          {row.amount}
                        </span>
                      </div>
                      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
                          <span className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>{row.system}</span>
                          <span style={{ width: 1, height: 12, background: 'var(--gz-rule)' }} />
                          <span className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>{row.duration}</span>
                          <span style={{ width: 1, height: 12, background: 'var(--gz-rule)' }} />
                          <Tag kind={row.status === 'Completed' ? 'ok' : 'err'}>{row.status}</Tag>
                        </div>
                      </div>
                    </button>

                    {/* Expanded details */}
                    {expandedRow === row.id && row.breakdown && (
                      <div style={{
                        background: 'var(--gz-card-tint)',
                        borderRadius: '0 0 var(--gz-r-inner) var(--gz-r-inner)',
                        padding: '14px',
                        borderLeft: `1px solid var(--gz-rule)`,
                        borderRight: `1px solid var(--gz-rule)`,
                        borderBottom: `1px solid var(--gz-rule)`,
                        marginTop: -1,
                      }}>
                        <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 12 }}>
                          <MetaRow label="System" value={row.system} />
                          <MetaRow label="Session ID" value={row.sessionId} />
                          <MetaRow label="Date" value={row.date} />
                          <MetaRow label="Duration" value={row.actualDuration} />
                        </div>
                        <hr className="gz-hr" style={{ margin: '12px 0' }} />
                        <div style={{ marginBottom: 12 }}>
                          <div className="gz-body" style={{ color: 'var(--gz-fg-3)', fontSize: 12, marginBottom: 8, fontWeight: 600, textTransform: 'uppercase' }}>Breakdown</div>
                          {row.breakdown.map((item, idx) => (
                            <MetaRow key={idx} label={item.label} value={item.amount} />
                          ))}
                          <hr className="gz-hr" style={{ margin: '8px 0' }} />
                          <MetaRow label="Total" value={row.amount} valueClass="gz-h3" />
                        </div>
                        <MetaRow label="Payment" value={row.payment} />
                        <MetaRow label="Credits earned" value={row.creditsEarned} />
                        <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
                          <button style={{
                            flex: 1,
                            background: 'var(--gz-pill-bg)',
                            border: 0,
                            padding: '10px',
                            borderRadius: 'var(--gz-r-chip)',
                            fontSize: 12,
                            fontWeight: 600,
                            color: 'var(--gz-fg)',
                            cursor: 'pointer',
                            fontFamily: 'inherit',
                          }}>
                            Download receipt
                          </button>
                          <button style={{
                            flex: 1,
                            background: 'transparent',
                            border: `1px solid rgba(${154}, ${42}, ${31}, 0.3)`,
                            color: 'var(--gz-err)',
                            padding: '10px',
                            borderRadius: 'var(--gz-r-chip)',
                            fontSize: 12,
                            fontWeight: 600,
                            cursor: 'pointer',
                            fontFamily: 'inherit',
                          }}>
                            File dispute
                          </button>
                        </div>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            ) : (
              <div className="gz-card" style={{ padding: '12px 14px', textAlign: 'center', opacity: 0.6 }}>
                <span className="gz-small">3 records</span>
              </div>
            )}
          </div>
        ))}

        {/* Load more */}
        <button className="gz-btn gz-btn--ghost" style={{ marginBottom: 12 }}>
          Load more
        </button>
      </Scroll>

      <BottomNav active="wallet" />
    </Phone>
  );
}

window.BillingHistoryScreen = BillingHistoryScreen;
