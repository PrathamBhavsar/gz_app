// Screen: Admin Password Reset
function AdminPasswordResetScreen() {
  return (
    <Phone>
      <div style={{ padding: '8px 16px 0', flexShrink: 0 }}>
        <button style={{ width: 38, height: 38, border: 0, background: 'transparent',
          color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 0 }}>
          {I.back}
        </button>
      </div>
      <Scroll>
        <div className="gz-h1">Reset password</div>
        <div style={{ height: 4 }} />
        <div className="gz-body-r">Enter your admin email and we'll send a reset link.</div>
        <div style={{ height: 32 }} />

        {/* Email input */}
        <input type="email" placeholder="Admin email address" readOnly
          style={{
            width: '100%', padding: '14px 16px', fontSize: 14, fontFamily: 'var(--gz-font)',
            fontWeight: 500, border: 0, borderRadius: 'var(--gz-r-inner)',
            background: 'var(--gz-pill-bg)', color: 'var(--gz-fg)', outline: 'none',
          }} />
        <div style={{ height: 24 }} />

        <Button variant="primary">Send reset link</Button>
        <div style={{ height: 20 }} />

        {/* Success state */}
        <div style={{
          background: 'var(--gz-ok-bg)', borderRadius: 14, padding: 16,
          display: 'flex', gap: 10, alignItems: 'flex-start',
        }}>
          <span style={{ color: 'var(--gz-ok)', flexShrink: 0 }}>
            {React.cloneElement(I.check, { style: { width: 20, height: 20 } })}
          </span>
          <span className="gz-body" style={{ color: 'var(--gz-ok)' }}>
            If an account exists with this email, a reset link has been sent.
          </span>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminPasswordResetScreen });
