// Screen: Admin Login
function AdminLoginScreen() {
  return (
    <Phone>
      <div style={{ padding: '8px 16px 0', flexShrink: 0 }}>
        <button style={{ width: 38, height: 38, border: 0, background: 'transparent',
          color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 0 }}>
          {I.back}
        </button>
      </div>
      <Scroll>
        <div style={{ height: 8 }} />
        <div className="gz-h1">Admin Portal</div>
        <div style={{ height: 4 }} />
        <div className="gz-body-r">Sign in to manage your store</div>
        <div style={{ height: 36 }} />

        {/* Email input */}
        <input type="email" placeholder="Email address" readOnly
          style={{
            width: '100%', padding: '14px 16px', fontSize: 14, fontFamily: 'var(--gz-font)',
            fontWeight: 500, border: 0, borderRadius: 'var(--gz-r-inner)',
            background: 'var(--gz-pill-bg)', color: 'var(--gz-fg)', outline: 'none',
          }} />
        <div style={{ height: 14 }} />

        {/* Password input */}
        <div style={{ position: 'relative' }}>
          <input type="password" placeholder="Password" readOnly
            style={{
              width: '100%', padding: '14px 16px', paddingRight: 48, fontSize: 14,
              fontFamily: 'var(--gz-font)', fontWeight: 500, border: 0,
              borderRadius: 'var(--gz-r-inner)', background: 'var(--gz-pill-bg)',
              color: 'var(--gz-fg)', outline: 'none',
            }} />
          <span style={{
            position: 'absolute', right: 14, top: '50%', transform: 'translateY(-50%)',
            color: 'var(--gz-fg-3)', display: 'flex',
          }}>
            <svg viewBox="0 0 24 24" style={{ width: 18, height: 18, stroke: 'currentColor', fill: 'none', strokeWidth: 1.7, strokeLinecap: 'round', strokeLinejoin: 'round' }}>
              <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-10-8-10-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 10 8 10 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
              <line x1="1" y1="1" x2="23" y2="23"/>
            </svg>
          </span>
        </div>
        <div style={{ height: 8 }} />

        {/* Forgot password link */}
        <div style={{ textAlign: 'right' }}>
          <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>Forgot password?</span>
        </div>
        <div style={{ height: 32 }} />

        <Button variant="primary">Sign in</Button>
        <div style={{ height: 24 }} />

        <div style={{ textAlign: 'center' }}>
          <span className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>Staff access · GameZone Operator</span>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminLoginScreen });
