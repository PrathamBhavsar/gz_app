// Screen: Register
function RegisterScreen() {
  return (
    <Phone>
      <div style={{ padding: '8px 16px 0', flexShrink: 0 }}>
        <button style={{ width: 38, height: 38, border: 0, background: 'transparent',
          color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 0 }}>
          {I.back}
        </button>
      </div>
      <Scroll>
        <div className="gz-h1" style={{ marginTop: 12 }}>Create an account</div>
        <div style={{ height: 28 }} />

        {/* Full Name — focused */}
        <div style={{ marginBottom: 16 }}>
          <input type="text" placeholder="Full Name" readOnly
            style={{
              width: '100%', padding: '14px 16px', fontSize: 14, fontFamily: 'var(--gz-font)',
              fontWeight: 500, border: 0, borderRadius: 'var(--gz-r-inner)',
              background: 'var(--gz-pill-bg)', color: 'var(--gz-fg)', outline: 'none',
              boxShadow: 'inset 0 0 0 1.5px var(--gz-fg)',
            }} />
        </div>

        {/* Phone Number */}
        <div style={{ marginBottom: 16 }}>
          <div style={{ position: 'relative' }}>
            <input type="tel" placeholder="Phone Number" readOnly
              style={{
                width: '100%', padding: '14px 16px', paddingRight: 90, fontSize: 14,
                fontFamily: 'var(--gz-font)', fontWeight: 500, border: 0,
                borderRadius: 'var(--gz-r-inner)', background: 'var(--gz-pill-bg)',
                color: 'var(--gz-fg)', outline: 'none',
              }} />
            <span style={{ position: 'absolute', right: 16, top: '50%', transform: 'translateY(-50%)',
              fontSize: 12, color: 'var(--gz-fg-3)', fontWeight: 500 }}>(Optional)</span>
          </div>
        </div>

        {/* Email Address */}
        <div style={{ marginBottom: 16 }}>
          <div style={{ position: 'relative' }}>
            <input type="email" placeholder="Email Address" readOnly
              style={{
                width: '100%', padding: '14px 16px', paddingRight: 90, fontSize: 14,
                fontFamily: 'var(--gz-font)', fontWeight: 500, border: 0,
                borderRadius: 'var(--gz-r-inner)', background: 'var(--gz-pill-bg)',
                color: 'var(--gz-fg)', outline: 'none',
              }} />
            <span style={{ position: 'absolute', right: 16, top: '50%', transform: 'translateY(-50%)',
              fontSize: 12, color: 'var(--gz-fg-3)', fontWeight: 500 }}>(Optional)</span>
          </div>
        </div>

        {/* Password */}
        <div style={{ marginBottom: 16 }}>
          <div style={{ position: 'relative' }}>
            <input type="password" placeholder="Password" readOnly
              style={{
                width: '100%', padding: '14px 16px', paddingRight: 90, fontSize: 14,
                fontFamily: 'var(--gz-font)', fontWeight: 500, border: 0,
                borderRadius: 'var(--gz-r-inner)', background: 'var(--gz-pill-bg)',
                color: 'var(--gz-fg)', outline: 'none',
              }} />
            <span style={{ position: 'absolute', right: 16, top: '50%', transform: 'translateY(-50%)',
              display: 'flex', alignItems: 'center', gap: 8 }}>
              <span style={{ fontSize: 12, color: 'var(--gz-fg-3)', fontWeight: 500 }}>(Optional)</span>
              <span style={{ color: 'var(--gz-fg-3)', display: 'flex' }}>
                <svg viewBox="0 0 24 24" style={{ width: 18, height: 18, stroke: 'currentColor', fill: 'none', strokeWidth: 1.7, strokeLinecap: 'round', strokeLinejoin: 'round' }}>
                  <path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="2.5"/>
                </svg>
              </span>
            </span>
          </div>
        </div>

        <div style={{ flex: 1 }} />
        <div style={{ paddingTop: 16 }}>
          <Button variant="primary">Register →</Button>
        </div>
        <div style={{ height: 32 }} />
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { RegisterScreen });
