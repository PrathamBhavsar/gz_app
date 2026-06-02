// Screen: Admin Session Management
function AdminSessionMgmtScreen() {
  return (
    <Phone>
      <AdminTopBar title="PC Station 03" onBack={() => {}}
        trailing={
          <span style={{
            background: 'var(--gz-ok-bg)', color: 'var(--gz-ok)',
            borderRadius: 999, padding: '2px 8px', fontSize: 11, fontWeight: 600,
            display: 'inline-flex', alignItems: 'center', gap: 4,
          }}>
            <span style={{ width: 6, height: 6, borderRadius: 999, background: 'var(--gz-ok)' }} />
            Live
          </span>
        }
      />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* System info bar */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 14 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
              <span style={{ color: 'var(--gz-rose)' }}>
                {React.cloneElement(I.pc, { style: { width: 32, height: 32 } })}
              </span>
              <div>
                <div className="gz-h2">PC Station 03</div>
                <div className="gz-small">PC Gaming Rig</div>
              </div>
            </div>
          </div>

          <div style={{ height: 16 }} />

          {/* Live timer card */}
          <div className="gz-card" style={{ padding: 24, borderRadius: 14, textAlign: 'center' }}>
            <div className="gz-hero-md">01:22:38</div>
            <div style={{ height: 10 }} />
            <div className="gz-progress" style={{ height: 6 }}>
              <i style={{ width: '65%', background: 'var(--gz-ok)' }} />
            </div>
            <div style={{ height: 8 }} />
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>57 min remaining</div>
          </div>

          <div style={{ height: 16 }} />

          {/* Player info card */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 14 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
              <span style={{ color: 'var(--gz-fg-3)' }}>
                {React.cloneElement(I.staff, { style: { width: 32, height: 32 } })}
              </span>
              <div>
                <div className="gz-body" style={{ fontWeight: 600 }}>Rahul Mehra</div>
                <div className="gz-small">Walk-in</div>
              </div>
            </div>
          </div>

          <div style={{ height: 16 }} />

          {/* Actions section */}
          <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 12 }}>Actions</div>
          <div style={{ display: 'flex', gap: 10 }}>
            {[
              { icon: I.clock, label: 'Pause', bg: 'var(--gz-card)', color: 'var(--gz-fg)' },
              { icon: I.spark, label: 'Resume', bg: 'var(--gz-card)', color: 'var(--gz-fg)' },
              { icon: I.x, label: 'End', bg: 'var(--gz-rose)', color: '#fff' },
              { icon: I.up, label: 'Extend', bg: 'var(--gz-card)', color: 'var(--gz-fg)' },
            ].map((a, i) => (
              <div key={i} style={{
                flex: 1, background: a.bg, color: a.color,
                borderRadius: 12, padding: '12px 8px', textAlign: 'center',
                boxShadow: a.bg === 'var(--gz-card)' ? 'inset 0 0 0 1px var(--gz-rule)' : 'none',
              }}>
                <div style={{ marginBottom: 4 }}>
                  {React.cloneElement(a.icon, { style: { width: 20, height: 20 } })}
                </div>
                <div className="gz-small" style={{ color: 'inherit' }}>{a.label}</div>
              </div>
            ))}
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminSessionMgmtScreen });
