// Screen: Admin Dispute Resolution
function AdminDisputesScreen() {
  const statusFilters = ['All', 'Open', 'In Review', 'Resolved'];
  const disputes = [
    { name: 'Rahul Mehra', desc: 'Overcharged for session duration', date: 'Jun 02, 2025', tag: 'err', tagLabel: 'Open', showBtn: true },
    { name: 'Priya Singh', desc: 'Credits not applied', date: 'Jun 01, 2025', tag: 'warn', tagLabel: 'In Review', showBtn: true },
    { name: 'Amit Kumar', desc: 'System not working properly', date: 'May 30, 2025', tag: 'ok', tagLabel: 'Resolved', showBtn: false },
    { name: 'Neha Reddy', desc: 'Booking cancelled, no refund', date: 'May 28, 2025', tag: 'err', tagLabel: 'Open', showBtn: true },
  ];

  return (
    <Phone>
      <AdminTopBar title="Disputes" onBack={() => {}} />

      {/* Status filter chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px 10px', overflowX: 'auto', scrollbarWidth: 'none', flexShrink: 0 }}>
        {statusFilters.map((f, i) => (
          <AdminChip key={f} label={f} active={i === 0} />
        ))}
      </div>

      <Scroll pad={false}>
        <div style={{ padding: '8px 16px 24px', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {disputes.map((d, i) => (
            <div key={i} className="gz-card" style={{ padding: 14, borderRadius: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
                <span className="gz-h3">{d.name}</span>
                <Tag kind={d.tag}>{d.tagLabel}</Tag>
              </div>
              <div className="gz-small" style={{ marginBottom: 8 }}>{d.desc}</div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span className="gz-small">{d.date}</span>
                {d.showBtn && (
                  <button className="gz-btn gz-btn--ghost gz-btn--sm" style={{ width: 'auto', padding: '0 12px', height: 32, fontSize: 12 }}>
                    Resolve →
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
Object.assign(window, { AdminDisputesScreen });
