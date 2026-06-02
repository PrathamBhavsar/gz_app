// Screen: Admin System Performance
function AdminSystemPerfScreen() {
  const systems = [
    { name: 'PC Station 01', type: 'PC Gaming Rig', icon: I.pc, revenue: '₹12,400', util: 78 },
    { name: 'PC Station 02', type: 'PC Gaming Rig', icon: I.pc, revenue: '₹11,200', util: 72 },
    { name: 'PS5 Console 01', type: 'PlayStation 5', icon: I.ps, revenue: '₹9,800', util: 65 },
    { name: 'Xbox Series X', type: 'Xbox Gaming', icon: I.xbox, revenue: '₹7,400', util: 45, lowUsage: true },
    { name: 'VR Pod 01', type: 'VR Experience', icon: I.vr, revenue: '₹14,200', util: 88 },
    { name: 'PC Station 03', type: 'PC Gaming Rig', icon: I.pc, revenue: '₹6,100', util: 38, lowUsage: true },
  ];

  return (
    <Phone>
      <AdminTopBar title="System Performance" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {systems.map((s, i) => (
              <div key={i} className="gz-card" style={{ padding: 14, borderRadius: 14 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 10 }}>
                  <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
                    <div style={{
                      width: 36, height: 36, borderRadius: 8, background: 'var(--gz-pill-bg)',
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                      color: 'var(--gz-fg-3)', flexShrink: 0,
                    }}>
                      {React.cloneElement(s.icon, { style: { width: 18, height: 18 } })}
                    </div>
                    <div>
                      <div className="gz-h3">{s.name}</div>
                      <div className="gz-small">{s.type}</div>
                    </div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div className="gz-body gz-num" style={{ fontWeight: 600 }}>{s.revenue}</div>
                    <div className="gz-small">revenue</div>
                  </div>
                </div>

                <div className="gz-small" style={{ marginBottom: 4 }}>Utilization: {s.util}%</div>
                <div className="gz-progress" style={{ height: 6 }}>
                  <i style={{ width: s.util + '%', background: 'var(--gz-card-tint-strong)' }} />
                </div>

                {s.lowUsage && (
                  <div style={{
                    marginTop: 8, background: 'var(--gz-warn-bg)', color: 'var(--gz-warn)',
                    borderRadius: 8, padding: '4px 8px', display: 'inline-flex', alignItems: 'center', gap: 4,
                    fontSize: 11, fontWeight: 600,
                  }}>
                    {React.cloneElement(I.warnT, { style: { width: 12, height: 12 } })}
                    Low usage — consider promotion
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminSystemPerfScreen });
