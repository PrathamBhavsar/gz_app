// Screen: Admin Booking Management
function AdminBookingsScreen() {
  const dates = ['Mon 2', 'Tue 3', 'Wed 4', 'Thu 5', 'Fri 6'];
  const statusFilters = ['All', 'Unpaid', 'Paid', 'Checked In', 'No Show', 'Cancelled'];
  const bookings = [
    { name: 'Rahul M.', time: '09:00 – 11:00', system: 'PC Station 01', tag: 'ok', tagLabel: 'Paid', showBtn: true },
    { name: 'Priya S.', time: '10:00 – 12:00', system: 'PS5 Console 01', tag: 'warn', tagLabel: 'Unpaid', showBtn: true },
    { name: 'Amit K.', time: '11:00 – 13:00', system: 'Xbox S X', tag: 'mute', tagLabel: 'Checked In', showBtn: false },
    { name: 'Neha R.', time: '14:00 – 16:00', system: 'VR Pod 01', tag: 'err', tagLabel: 'No Show', showBtn: false },
  ];

  return (
    <Phone>
      <AdminTopBar title="Bookings" onBack={() => {}} />

      {/* Date strip */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px 10px', overflowX: 'auto', scrollbarWidth: 'none', flexShrink: 0 }}>
        {dates.map((d, i) => (
          <span key={d} style={{
            padding: '6px 14px', borderRadius: 999, flexShrink: 0,
            background: i === 2 ? 'var(--gz-rose)' : 'var(--gz-pill-bg)',
            color: i === 2 ? '#fff' : 'var(--gz-fg-2)',
            fontSize: 13, fontWeight: 600,
          }}>{d}</span>
        ))}
      </div>

      {/* Status filter chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px 10px', overflowX: 'auto', scrollbarWidth: 'none', flexShrink: 0 }}>
        {statusFilters.map((f, i) => (
          <AdminChip key={f} label={f} active={i === 0} />
        ))}
      </div>

      <hr className="gz-hr" style={{ flexShrink: 0 }} />

      <Scroll pad={false}>
        <div style={{ padding: '8px 16px 24px', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {bookings.map((b, i) => (
            <div key={i} className="gz-card" style={{ padding: 14, borderRadius: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div style={{ flex: 1 }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 2 }}>
                    <span className="gz-h3">{b.name}</span>
                    <Tag kind={b.tag}>{b.tagLabel}</Tag>
                  </div>
                  <div className="gz-small">{b.time} · {b.system}</div>
                </div>
                {b.showBtn && (
                  <button className="gz-btn gz-btn--ghost gz-btn--sm" style={{ width: 'auto', padding: '0 12px', height: 32, fontSize: 12 }}>
                    Check In
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
Object.assign(window, { AdminBookingsScreen });
