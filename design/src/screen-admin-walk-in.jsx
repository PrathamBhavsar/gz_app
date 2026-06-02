// Screen: Admin Walk-in Booking
function AdminWalkInScreen() {
  return (
    <Phone>
      <AdminTopBar title="Walk-in Booking" onBack={() => {}} />

      {/* Step indicator */}
      <div style={{ padding: '4px 24px 12px', display: 'flex', alignItems: 'center', gap: 0, flexShrink: 0 }}>
        {[1, 2, 3].map((step, i) => (
          <React.Fragment key={step}>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, width: 60 }}>
              <div style={{
                width: 24, height: 24, borderRadius: 999,
                background: step === 1 ? 'var(--gz-fg)' : 'transparent',
                border: step === 1 ? 'none' : '2px solid var(--gz-rule)',
                color: step === 1 ? '#fff' : 'var(--gz-fg-3)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 11, fontWeight: 700,
              }}>{step}</div>
              <span className="gz-small" style={{
                color: step === 1 ? 'var(--gz-fg)' : 'var(--gz-fg-3)',
                fontWeight: step === 1 ? 600 : 500, fontSize: 10,
              }}>
                {['Customer', 'System', 'Payment'][i]}
              </span>
            </div>
            {i < 2 && <div style={{ flex: 1, height: 2, background: 'var(--gz-rule)', marginTop: -12 }} />}
          </React.Fragment>
        ))}
      </div>

      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 8 }} />

          {/* Search bar */}
          <div style={{
            background: 'var(--gz-card)', borderRadius: 12, padding: '12px 14px',
            display: 'flex', alignItems: 'center', gap: 8,
          }}>
            <span style={{ color: 'var(--gz-fg-3)' }}>
              {React.cloneElement(I.search, { style: { width: 18, height: 18 } })}
            </span>
            <span className="gz-body-r" style={{ color: 'var(--gz-fg-3)' }}>Search by phone, name, or email…</span>
          </div>

          <div style={{ height: 12 }} />

          <div style={{ textAlign: 'center' }}>
            <span className="gz-small">— or —</span>
          </div>

          <div style={{ height: 12 }} />

          {/* New customer card */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 12 }}>New customer</div>
            <input type="text" placeholder="Full name" readOnly
              style={{
                width: '100%', padding: '12px 14px', fontSize: 14,
                fontFamily: 'var(--gz-font)', fontWeight: 500, border: 0,
                borderRadius: 10, background: 'var(--gz-pill-bg)',
                color: 'var(--gz-fg)', outline: 'none', marginBottom: 10,
              }} />
            <input type="tel" placeholder="Phone number" readOnly
              style={{
                width: '100%', padding: '12px 14px', fontSize: 14,
                fontFamily: 'var(--gz-font)', fontWeight: 500, border: 0,
                borderRadius: 10, background: 'var(--gz-pill-bg)',
                color: 'var(--gz-fg)', outline: 'none',
              }} />
          </div>

          <div style={{ height: 12 }} />

          {/* Existing customer result */}
          <div className="gz-card" style={{ padding: 14, borderRadius: 12 }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <Avatar size="md" index={0}>R</Avatar>
              <div style={{ flex: 1 }}>
                <div className="gz-body" style={{ fontWeight: 600 }}>Rahul Mehra</div>
                <div className="gz-small">+91 98765 43210</div>
              </div>
              <span style={{ color: 'var(--gz-fg-3)' }}>
                {React.cloneElement(I.chev, { style: { width: 16, height: 16 } })}
              </span>
            </div>
          </div>
        </div>
      </Scroll>

      {/* Bottom bar */}
      <div style={{
        background: 'var(--gz-card)', borderTop: '1px solid var(--gz-rule)',
        padding: '12px 16px', flexShrink: 0,
      }}>
        <Button variant="primary">Next: Select System →</Button>
      </div>
    </Phone>
  );
}
Object.assign(window, { AdminWalkInScreen });
