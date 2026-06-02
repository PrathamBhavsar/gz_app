// Screen: Admin Revenue Analytics
function AdminRevenueScreen() {
  const groupFilters = ['Daily', 'Weekly', 'Monthly'];
  const dailyData = [
    { date: 'Jun 01', sessions: '28', revenue: '₹8,400' },
    { date: 'Jun 02', sessions: '31', revenue: '₹9,300' },
    { date: 'Jun 03', sessions: '25', revenue: '₹7,500' },
    { date: 'Jun 04', sessions: '29', revenue: '₹8,700' },
    { date: 'Jun 05', sessions: '33', revenue: '₹9,900' },
    { date: 'Jun 06', sessions: '34', revenue: '₹10,200' },
  ];

  return (
    <Phone>
      <AdminTopBar title="Revenue" onBack={() => {}} />

      {/* Group-by chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px 10px', flexShrink: 0 }}>
        {groupFilters.map((f, i) => (
          <AdminChip key={f} label={f} active={i === 0} />
        ))}
      </div>

      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* Summary card */}
          <div className="gz-card" style={{ padding: 20, borderRadius: 16 }}>
            <div className="gz-meta" style={{ marginBottom: 6 }}>Total Revenue</div>
            <div className="gz-hero-md">₹1,84,200</div>
            <div style={{ height: 6 }} />
            <div className="gz-small">Last 30 days</div>
          </div>

          <div style={{ height: 12 }} />

          {/* Payment breakdown */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Payment breakdown</div>
            <MetaRow label="Cash" value="₹72,400" />
            <MetaRow label="UPI" value="₹89,200" />
            <MetaRow label="Credits" value="₹22,600" />
            <hr className="gz-hr" style={{ margin: '4px 0' }} />
            <MetaRow label="Total" value="₹1,84,200" valueClass="gz-body" />
          </div>

          <div style={{ height: 12 }} />

          {/* Revenue table */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 12 }}>Daily breakdown</div>
            <div style={{ display: 'flex', padding: '0 0 8px', borderBottom: '1px solid var(--gz-rule)' }}>
              <span className="gz-meta" style={{ flex: 1 }}>DATE</span>
              <span className="gz-meta" style={{ width: 70, textAlign: 'right' }}>SESSIONS</span>
              <span className="gz-meta" style={{ width: 80, textAlign: 'right' }}>REVENUE</span>
            </div>
            {dailyData.map((row, i) => (
              <div key={i} style={{ display: 'flex', padding: '10px 0', borderBottom: i < dailyData.length - 1 ? '1px solid var(--gz-rule)' : 'none' }}>
                <span className="gz-body gz-num" style={{ flex: 1 }}>{row.date}</span>
                <span className="gz-body gz-num" style={{ width: 70, textAlign: 'right' }}>{row.sessions}</span>
                <span className="gz-body gz-num" style={{ width: 80, textAlign: 'right' }}>{row.revenue}</span>
              </div>
            ))}
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminRevenueScreen });
