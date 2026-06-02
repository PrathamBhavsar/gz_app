// Screen: Admin Management Hub
function AdminManagementScreen() {
  return (
    <Phone>
      <AdminTopBar title="Management" />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            <AdminNavTile icon={I.scale} iconColor="#9A2A1F" label="Pricing Rules" />
            <AdminNavTile icon={I.coin} iconColor="#2A4A8A" label="Billing & Payments" />
            <AdminNavTile icon={I.gift} iconColor="#2E7A3C" label="Campaigns" />
            <AdminNavTile icon={I.star} iconColor="#8A5A12" label="Credits" />
            <AdminNavTile icon={I.sos} iconColor="#9A2A1F" label="Disputes" />
          </div>
        </div>
      </Scroll>
      <AdminBottomNav active="management" />
    </Phone>
  );
}
Object.assign(window, { AdminManagementScreen });
