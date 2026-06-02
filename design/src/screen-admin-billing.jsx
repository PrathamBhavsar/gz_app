// Screen: Admin Billing & Payments
function AdminBillingScreen() {
  const statusFilters = ['All', 'Unpaid', 'Paid', 'Overridden'];
  const records = [
    { name: 'Rahul Mehra', detail: 'PC Station 01 · 2h 10m', amount: '₹1,740', tag: 'ok', tagLabel: 'Paid', showOverride: false },
    { name: 'Priya Singh', detail: 'PS5 Console · 1h 30m', amount: '₹1,200', tag: 'warn', tagLabel: 'Unpaid', showOverride: true },
    { name: 'Amit Kumar', detail: 'Xbox Series X · 45m', amount: '₹600', tag: 'mute', tagLabel: 'Overridden', showOverride: false },
    { name: 'Neha Reddy', detail: 'VR Pod 01 · 2h 00m', amount: '₹3,000', tag: 'ok', tagLabel: 'Paid', showOverride: false },
  ];

  return (
    <Phone>
      <AdminTopBar title="Billing" onBack={() => {}} />

      {/* Status filter chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px 10px', overflowX: 'auto', scrollbarWidth: 'none', flexShrink: 0 }}>
        {statusFilters.map((f, i) => (
          <AdminChip key={f} label={f} active={i === 0} />
        ))}
      </div>

      <Scroll pad={false}>
        <div style={{ padding: '8px 16px 24px', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {records.map((r, i) => (
            <div key={i} className="gz-card" style={{ padding: 14, borderRadius: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
                <span className="gz-h3">{r.name}</span>
                <Tag kind={r.tag}>{r.tagLabel}</Tag>
              </div>
              <div className="gz-small">{r.detail}</div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 8 }}>
                <span className="gz-body gz-num" style={{ fontWeight: 600 }}>{r.amount}</span>
                {r.showOverride && (
                  <button className="gz-btn gz-btn--ghost gz-btn--sm" style={{ width: 'auto', padding: '0 12px', height: 32, fontSize: 12 }}>
                    Override
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminBillingScreen });
