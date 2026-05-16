function ResetPasswordScreen() {
  const [newPassword, setNewPassword] = React.useState('');
  const [confirmPassword, setConfirmPassword] = React.useState('');
  const [showNew, setShowNew] = React.useState(false);
  const [showConfirm, setShowConfirm] = React.useState(false);
  const [timeLeft, setTimeLeft] = React.useState('24:38');
  const [tokenExpired, setTokenExpired] = React.useState(false);
  const [showSuccess, setShowSuccess] = React.useState(false);

  React.useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft(prev => {
        const [min, sec] = prev.split(':').map(Number);
        let newMin = min, newSec = sec - 1;
        if (newSec < 0) { newMin--; newSec = 59; }
        if (newMin < 0) return '00:00';
        return `${newMin}:${newSec < 10 ? '0' : ''}${newSec}`;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const getStrength = () => {
    let score = 0;
    if (newPassword.length >= 8) score++;
    if (/[A-Z]/.test(newPassword)) score++;
    if (/[0-9]/.test(newPassword)) score++;
    if (/[!@#$%^&*]/.test(newPassword)) score++;
    return score;
  };

  const strength = getStrength();
  const strengthLabels = ['Weak', 'Fair', 'Good', 'Strong'];
  const strengthColors = ['#F2DAD5', '#F6E6C8', '#DDE9D2', '#DDEFD9'];
  const passwordsMatch = newPassword === confirmPassword && newPassword.length > 0;
  const canSubmit = strength >= 2 && passwordsMatch;

  if (showSuccess) {
    return (
      <Phone>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', padding: '40px 20px 20px' }}>
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 20 }}>
            <svg width="64" height="64" viewBox="0 0 64 64" style={{ color: 'var(--gz-ok)' }}>
              <circle cx="32" cy="32" r="28" fill="none" stroke="currentColor" strokeWidth="2"/>
              <path d="M20 32l8 8 16-16" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
            <div style={{ fontSize: 22, fontWeight: 700, textAlign: 'center', color: 'var(--gz-fg)' }}>
              Password reset!
            </div>
            <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', textAlign: 'center' }}>
              Sign in with your new password
            </div>
          </div>
          <Button>
            Go to sign in →
          </Button>
        </div>
      </Phone>
    );
  }

  if (tokenExpired) {
    return (
      <Phone>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', padding: '40px 20px 20px' }}>
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 20 }}>
            <svg width="64" height="64" viewBox="0 0 64 64" style={{ color: 'var(--gz-fg)' }}>
              <circle cx="32" cy="32" r="28" fill="none" stroke="currentColor" strokeWidth="2"/>
              <path d="M32 16v16" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
              <path d="M32 40v16" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
            </svg>
            <div style={{ fontSize: 22, fontWeight: 700, textAlign: 'center', color: 'var(--gz-fg)' }}>
              This link has expired
            </div>
            <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', textAlign: 'center' }}>
              Reset links are valid for 30 minutes only
            </div>
          </div>
          <Button style={{ marginBottom: 10 }}>
            Request a new link →
          </Button>
        </div>
      </Phone>
    );
  }

  return (
    <Phone>
      <TopBar title="Reset password" onBack={() => {}} />

      <Scroll>
        {/* Lock icon illustration - Walle-inspired avatar */}
        <div style={{
          height: 120,
          marginBottom: 24,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
          <Avatar size="xl" index={2} icon={
            <svg viewBox="0 0 24 24" style={{ stroke: 'currentColor', fill: 'none', strokeWidth: 1.5 }}>
              <rect x="5" y="11" width="14" height="9" rx="2" />
              <path d="M8 11V8a4 4 0 0 1 8 0v3" />
              <circle cx="12" cy="15.5" r="1.5" fill="currentColor" />
            </svg>
          } />
        </div>

        <h1 className="gz-h1" style={{ marginBottom: 8, textAlign: 'center' }}>Create new password</h1>
        <p className="gz-body-r" style={{ textAlign: 'center', marginBottom: 20, color: 'var(--gz-fg-2)' }}>
          Choose something strong you haven't used before. Link expires in {timeLeft}.
        </p>

        {/* New password field */}
        <div style={{ marginBottom: 16 }}>
          <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 8 }}>New password</div>
          <div style={{ display: 'flex', alignItems: 'center', background: 'var(--gz-card)', border: '1px solid var(--gz-rule)', borderRadius: 'var(--gz-r-inner)', paddingLeft: 12, paddingRight: 12, height: 44 }}>
            <input
              autoFocus
              type={showNew ? 'text' : 'password'}
              placeholder="Enter new password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              style={{ flex: 1, border: 'none', background: 'none', fontSize: 14, color: 'var(--gz-fg)', outline: 'none', fontFamily: 'inherit' }}
            />
            <button style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 18, color: 'var(--gz-fg-2)' }} onClick={() => setShowNew(!showNew)}>
              <svg viewBox="0 0 24 24" style={{ width: 18, height: 18, stroke: 'currentColor', fill: 'none', strokeWidth: 2 }}>
                {showNew ? (
                  <>
                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </>
                ) : (
                  <>
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-10-8-10-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 10 8 10 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                    <line x1="1" y1="1" x2="23" y2="23"/>
                  </>
                )}
              </svg>
            </button>
          </div>
        </div>

        {/* Strength indicator */}
        {newPassword.length > 0 && (
          <div style={{ marginBottom: 16 }}>
            <div style={{ display: 'flex', gap: 4, marginBottom: 8 }}>
              {[0, 1, 2, 3].map(i => (
                <div key={i} style={{ flex: 1, height: 4, background: i < strength ? strengthColors[strength - 1] : '#E4E4E0', borderRadius: 2 }} />
              ))}
            </div>
            <div style={{ fontSize: 12, fontWeight: 600, color: strengthColors[strength - 1] || '#8A8A85', marginBottom: 8 }}>
              {strengthLabels[strength - 1] || 'Weak'}
            </div>
            <div className="gz-small" style={{ color: 'var(--gz-fg-2)', display: 'flex', flexDirection: 'column', gap: 4 }}>
              <div style={{ color: /(.{8,})/.test(newPassword) ? '#1F8A5B' : 'var(--gz-fg-3)' }}>
                {/(.{8,})/.test(newPassword) ? '✓' : '○'} At least 8 characters
              </div>
              <div style={{ color: /[A-Z]/.test(newPassword) ? '#1F8A5B' : 'var(--gz-fg-3)' }}>
                {/[A-Z]/.test(newPassword) ? '✓' : '○'} One uppercase letter
              </div>
              <div style={{ color: /[0-9]/.test(newPassword) ? '#1F8A5B' : 'var(--gz-fg-3)' }}>
                {/[0-9]/.test(newPassword) ? '✓' : '○'} One number
              </div>
              <div style={{ color: /[!@#$%^&*]/.test(newPassword) ? '#1F8A5B' : 'var(--gz-fg-3)' }}>
                {/[!@#$%^&*]/.test(newPassword) ? '✓' : '○'} One special character
              </div>
            </div>
          </div>
        )}

        {/* Confirm password field */}
        <div style={{ marginBottom: 20 }}>
          <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 8 }}>Confirm new password</div>
          <div style={{ display: 'flex', alignItems: 'center', background: 'var(--gz-card)', border: '1px solid var(--gz-rule)', borderRadius: 'var(--gz-r-inner)', paddingLeft: 12, paddingRight: 12, height: 44 }}>
            <input
              type={showConfirm ? 'text' : 'password'}
              placeholder="Confirm new password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              style={{ flex: 1, border: 'none', background: 'none', fontSize: 14, color: 'var(--gz-fg)', outline: 'none', fontFamily: 'inherit' }}
            />
            <button style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 18, color: 'var(--gz-fg-2)' }} onClick={() => setShowConfirm(!showConfirm)}>
              <svg viewBox="0 0 24 24" style={{ width: 18, height: 18, stroke: 'currentColor', fill: 'none', strokeWidth: 2 }}>
                {showConfirm ? (
                  <>
                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </>
                ) : (
                  <>
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-10-8-10-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 10 8 10 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                    <line x1="1" y1="1" x2="23" y2="23"/>
                  </>
                )}
              </svg>
            </button>
          </div>
          {confirmPassword.length > 0 && (
            <div className="gz-small" style={{ marginTop: 6, color: passwordsMatch ? '#1F8A5B' : '#C85E54' }}>
              {passwordsMatch ? '✓' : '✗'} {passwordsMatch ? 'Passwords match' : "Passwords don't match"}
            </div>
          )}
        </div>

        <Button
          onClick={() => setShowSuccess(true)}
          disabled={!canSubmit}
          style={{
            opacity: canSubmit ? 1 : 0.5,
            marginBottom: 12,
          }}
        >
          Reset password
        </Button>

        {/* Demo toggle */}
        <button
          onClick={() => setTokenExpired(true)}
          style={{ width: '100%', fontSize: 10, color: 'var(--gz-fg-3)', background: 'none', border: 'none', cursor: 'pointer', padding: '12px 0' }}
        >
          [demo: expire token]
        </button>
      </Scroll>
    </Phone>
  );
}

Object.assign(window, { ResetPasswordScreen });
