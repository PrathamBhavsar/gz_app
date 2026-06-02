// Screen: Admin Staff Management
function AdminStaffScreen() {
  const staff = [
    { name: 'Raj Kumar', email: 'raj@store.in', role: 'Super Admin', tag: 'purple', idx: 0 },
    { name: 'Meera Nair', email: 'meera@store.in', role: 'Admin', tag: 'info', idx: 1 },
    { name: 'Suresh Verma', email: 'suresh@store.in', role: 'Staff', tag: 'mute', idx: 2 },
    { name: 'Ananya Das', email: 'ananya@store.in', role: 'Staff', tag: 'mute', idx: 3 },
  ];

  return (
    <Phone>
      <AdminTopBar title="Staff" onBack={() => {}}
        trailing={
          <span style={{ color: 'var(--gz-fg-3)' }}>
            {React.cloneElement(I.plus, { style: { width: 20, height: 20 } })}
          </span>
        }
      />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* Role legend */}
          <div style={{ display: 'flex', gap: 6, marginBottom: 12 }}>
            <Tag kind="purple">Super Admin</Tag>
            <Tag kind="info">Admin</Tag>
            <Tag kind="mute">Staff</Tag>
          </div>

          {/* Staff cards */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {staff.map((s, i) => (
              <div key={i} className="gz-card" style={{ padding: 14, borderRadius: 14 }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <Avatar size="lg" index={s.idx}>{s.name.charAt(0)}</Avatar>
                  <div style={{ flex: 1 }}>
                    <div className="gz-h3">{s.name}</div>
                    <div className="gz-small">{s.email}</div>
                  </div>
                  <Tag kind={s.tag}>{s.role}</Tag>
                  {s.tag === 'purple' ? null : (
                    <span style={{ color: 'var(--gz-err)', marginLeft: 4 }}>
                      {React.cloneElement(I.bin, { style: { width: 18, height: 18 } })}
                    </span>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminStaffScreen });
