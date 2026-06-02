// Screen: Admin Campaign Management
function AdminCampaignsScreen() {
  const campaigns = [
    { name: 'Welcome Bonus', desc: 'Earn 2× credits on first booking', redemptions: '142', expires: 'Dec 31, 2025', tag: 'ok', tagLabel: 'Active' },
    { name: 'Happy Hours', desc: '50% off 2–5 PM Mon–Thu', redemptions: '89', expires: 'Dec 31, 2025', tag: 'ok', tagLabel: 'Active' },
    { name: 'Summer Blast', desc: 'Free hour with 2-hour booking', redemptions: '234', expires: 'Sep 30, 2025', tag: 'mute', tagLabel: 'Paused' },
  ];

  return (
    <Phone>
      <AdminTopBar title="Campaigns" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            {campaigns.map((c, i) => (
              <div key={i} className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
                  <span className="gz-h3">{c.name}</span>
                  <Tag kind={c.tag}>{c.tagLabel}</Tag>
                </div>
                <div className="gz-small" style={{ marginBottom: 10 }}>{c.desc}</div>
                <MetaRow label="Redemptions" value={c.redemptions} />
                <MetaRow label="Expires" value={c.expires} />
                <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
                  <button className="gz-btn gz-btn--ghost gz-btn--sm" style={{ flex: 1 }}>Pause</button>
                  <button className="gz-btn gz-btn--ghost gz-btn--sm" style={{ flex: 1 }}>Edit</button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminCampaignsScreen });
