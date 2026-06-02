// Screen: Admin Pricing Rules
function AdminPricingScreen() {
  const rules = [
    { name: 'Standard Rate', rate: '₹80/hour · All day', active: true, tags: ['PC', 'All hours'] },
    { name: 'Peak Hour', rate: '₹120/hour · 6 PM–10 PM', active: true, tags: ['All', 'Evening'] },
    { name: 'Weekend Rate', rate: '₹100/hour · Sat–Sun', active: true, tags: ['All', 'Weekend'] },
    { name: 'VR Premium', rate: '₹150/hour', active: false, tags: ['VR', 'All hours'] },
  ];

  return (
    <Phone>
      <AdminTopBar title="Pricing Rules" onBack={() => {}}
        trailing={
          <span style={{ color: 'var(--gz-fg-3)' }}>
            {React.cloneElement(I.plus, { style: { width: 20, height: 20 } })}
          </span>
        }
      />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {rules.map((r, i) => (
              <div key={i} className="gz-card" style={{ padding: 16, borderRadius: 14 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <div className="gz-h3">{r.name}</div>
                    <div className="gz-small" style={{ marginTop: 2 }}>{r.rate}</div>
                  </div>
                  <AdminToggle active={r.active} />
                </div>
                <div style={{ display: 'flex', gap: 6, marginTop: 10 }}>
                  {r.tags.map((t, j) => (
                    <Tag key={j} kind="mute">{t}</Tag>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminPricingScreen });
