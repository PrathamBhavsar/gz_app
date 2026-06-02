// Screen: Admin Store Config
function AdminConfigScreen() {
  return (
    <Phone>
      <AdminTopBar title="Store Config" onBack={() => {}}
        trailing={
          <button className="gz-btn gz-btn--ghost gz-btn--sm" style={{ width: 'auto', padding: '0 12px', height: 32, fontSize: 12 }}>
            Save
          </button>
        }
      />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* Booking settings */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16, marginBottom: 12 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Booking settings</div>
            <AdminInput label="Booking window (minutes)" value="1440" />
            <AdminInput label="Payment window (minutes)" value="30" />
            <AdminInput label="No-show grace (minutes)" value="10" />
            <AdminInput label="Max booking duration (min)" value="240" style={{ marginBottom: 0 }} />
          </div>

          {/* Operating hours */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16, marginBottom: 12 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Operating hours</div>
            <div style={{ display: 'flex', gap: 10 }}>
              <div style={{ flex: 1 }}>
                <div className="gz-meta" style={{ marginBottom: 4 }}>Opens</div>
                <div style={{
                  background: 'var(--gz-pill-bg)', borderRadius: 10,
                  padding: '10px 12px', fontSize: 14, fontWeight: 500,
                }}>10:00</div>
              </div>
              <div style={{ flex: 1 }}>
                <div className="gz-meta" style={{ marginBottom: 4 }}>Closes</div>
                <div style={{
                  background: 'var(--gz-pill-bg)', borderRadius: 10,
                  padding: '10px 12px', fontSize: 14, fontWeight: 500,
                }}>23:00</div>
              </div>
            </div>
          </div>

          {/* Operations */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Operations</div>

            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
              <div>
                <div className="gz-body" style={{ fontWeight: 600 }}>Allow walk-ins</div>
                <div className="gz-small">Accept on-site bookings</div>
              </div>
              <AdminToggle active={true} />
            </div>

            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div>
                <div className="gz-body" style={{ fontWeight: 600 }}>Auto-start on check-in</div>
                <div className="gz-small">Begin session immediately on check-in</div>
              </div>
              <AdminToggle active={true} />
            </div>
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminConfigScreen });
