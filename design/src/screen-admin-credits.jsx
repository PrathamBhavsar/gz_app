// Screen: Admin Credits Management
function AdminCreditsScreen() {
  const transactions = [
    { label: 'Booking credit', amount: '+200', color: 'var(--gz-ok)', date: 'Jun 02' },
    { label: 'Session deduct', amount: '−150', color: 'var(--gz-err)', date: 'Jun 01' },
    { label: 'Welcome bonus', amount: '+500', color: 'var(--gz-ok)', date: 'May 28' },
  ];

  return (
    <Phone>
      <AdminTopBar title="Credits" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* Search bar */}
          <div style={{
            background: 'var(--gz-card)', borderRadius: 12, padding: '12px 14px',
            display: 'flex', alignItems: 'center', gap: 8,
          }}>
            <span style={{ color: 'var(--gz-fg-3)' }}>
              {React.cloneElement(I.search, { style: { width: 18, height: 18 } })}
            </span>
            <span className="gz-body-r" style={{ color: 'var(--gz-fg-3)' }}>Search by phone, email, or name…</span>
          </div>

          <div style={{ height: 14 }} />

          {/* Player result card */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 14 }}>
              <Avatar size="lg" index={0}>R</Avatar>
              <div>
                <div className="gz-h3">Rahul Mehra</div>
                <div className="gz-small">+91 98765 43210</div>
              </div>
            </div>

            {/* Balance highlight */}
            <div style={{
              background: 'var(--gz-card-tint)', borderRadius: 12, padding: 14, textAlign: 'center',
            }}>
              <div className="gz-meta" style={{ marginBottom: 4 }}>CREDIT BALANCE</div>
              <div className="gz-hero-md">850</div>
              <div className="gz-small">credits</div>
            </div>

            <div style={{ height: 14 }} />

            {/* Transaction history */}
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span className="gz-h3">Recent transactions</span>
              <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>See all →</span>
            </div>

            {transactions.map((t, i) => (
              <div key={i} style={{
                display: 'flex', justifyContent: 'space-between', alignItems: 'center',
                padding: '10px 0',
                borderTop: '1px solid var(--gz-rule)',
              }}>
                <div>
                  <div className="gz-body" style={{ fontSize: 13 }}>{t.label}</div>
                  <div className="gz-small">{t.date}</div>
                </div>
                <span className="gz-body gz-num" style={{ fontWeight: 600, color: t.color }}>{t.amount}</span>
              </div>
            ))}

            <div style={{ height: 14 }} />

            {/* Action buttons */}
            <div style={{ display: 'flex', gap: 10 }}>
              <button className="gz-btn gz-btn--ghost" style={{ flex: 1, height: 44, fontSize: 13 }}>Deduct credits</button>
              <Button variant="primary" style={{ flex: 1, height: 44, fontSize: 13 }}>Add credits</Button>
            </div>
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminCreditsScreen });
