// Screen: Admin Notifications Broadcast
function AdminNotificationsScreen() {
  return (
    <Phone>
      <AdminTopBar title="Notifications" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* Channel selector */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16, marginBottom: 12 }}>
            <div className="gz-h3" style={{ marginBottom: 12 }}>Broadcast channel</div>
            <div style={{ display: 'flex', gap: 8 }}>
              <AdminChip label="Push" active={true} />
              <AdminChip label="Email" active={false} />
              <AdminChip label="SMS" active={false} />
            </div>
          </div>

          {/* Target selector */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16, marginBottom: 12 }}>
            <div className="gz-h3" style={{ marginBottom: 12 }}>Audience</div>
            <div style={{ display: 'flex', gap: 8 }}>
              <AdminChip label="All Players" active={true} />
              <AdminChip label="Active Now" active={false} />
            </div>
          </div>

          {/* Message compose */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16, marginBottom: 12 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Compose</div>

            <div className="gz-meta" style={{ marginBottom: 4 }}>Notification title</div>
            <div style={{
              background: 'var(--gz-pill-bg)', borderRadius: 10,
              padding: '12px 14px', fontSize: 14, fontWeight: 500,
              color: 'var(--gz-fg)', marginBottom: 10,
            }}>Happy Hours start at 2 PM!</div>

            <div className="gz-meta" style={{ marginBottom: 4 }}>Message body</div>
            <div style={{
              background: 'var(--gz-pill-bg)', borderRadius: 10,
              padding: '12px 14px', fontSize: 14, fontWeight: 400,
              color: 'var(--gz-fg-2)', minHeight: 80, lineHeight: 1.5,
            }}>Get 50% off all systems from 2 PM to 5 PM today.</div>
          </div>

          {/* Preview card */}
          <div style={{
            background: 'var(--gz-info-bg)', borderRadius: 14, padding: 14, marginBottom: 12,
          }}>
            <div className="gz-meta" style={{ marginBottom: 8 }}>Preview</div>
            <div style={{ display: 'flex', gap: 10, alignItems: 'flex-start' }}>
              <div style={{
                width: 40, height: 40, borderRadius: 10, background: 'var(--gz-btn)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: 'var(--gz-card-tint-strong)', fontFamily: 'var(--gz-mono)',
                fontSize: 14, fontWeight: 700, flexShrink: 0,
              }}>GZ</div>
              <div>
                <div className="gz-body" style={{ fontWeight: 600 }}>Happy Hours start at 2 PM!</div>
                <div className="gz-small" style={{ marginTop: 2, color: 'var(--gz-fg-2)' }}>Get 50% off all systems from 2 PM to 5 PM today.</div>
              </div>
            </div>
          </div>

          <div style={{ height: 4 }} />

          <Button variant="primary">Send Notification</Button>

          <div style={{ height: 12 }} />

          <div style={{ textAlign: 'center' }}>
            <span className="gz-small">Will be sent to 142 players</span>
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminNotificationsScreen });
