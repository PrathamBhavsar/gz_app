// Screen: Admin Store Hub
function AdminStoreScreen() {
  return (
    <Phone>
      <AdminTopBar title="Store" />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            <AdminNavTile icon={I.pc} iconColor="#2A4A8A" label="System Management" />
            <AdminNavTile icon={I.staff} iconColor="#5A3A82" label="Staff Management" />
            <AdminNavTile icon={I.filter} iconColor="#8A8A85" label="Store Config" />
            <AdminNavTile icon={I.bell} iconColor="#8A5A12" label="Notifications" />
          </div>
        </div>
      </Scroll>
      <AdminBottomNav active="store" />
    </Phone>
  );
}
Object.assign(window, { AdminStoreScreen });
