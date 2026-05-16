// Screen 21: Forgot Password
// Two states: request reset (default) → email sent (after CTA)

const { useState, useEffect } = React;

function ForgotPasswordScreen() {
  const [state, setState] = useState('request'); // 'request' | 'sent'
  const [email, setEmail] = useState('');
  const [countdownSecs, setCountdownSecs] = useState(0);
  const [showToast, setShowToast] = useState(false);

  // Countdown timer for "Resend in X:XX"
  useEffect(() => {
    if (countdownSecs <= 0) return;
    const timer = setTimeout(() => setCountdownSecs(countdownSecs - 1), 1000);
    return () => clearTimeout(timer);
  }, [countdownSecs]);

  const isValidEmail = email.includes('@') && email.includes('.');
  
  const handleSendLink = () => {
    if (!isValidEmail) return;
    setState('sent');
    setCountdownSecs(60);
  };

  const handleResend = () => {
    if (countdownSecs > 0) return;
    setCountdownSecs(60);
    setShowToast(true);
    setTimeout(() => setShowToast(false), 1500);
  };

  const handleBack = () => {
    if (state === 'sent') {
      setState('request');
      setCountdownSecs(0);
    }
  };

  const formatCountdown = (secs) => {
    const mins = Math.floor(secs / 60);
    const s = secs % 60;
    return `${mins}:${s.toString().padStart(2, '0')}`;
  };

  return (
    <Phone>
      <TopBar 
        title={state === 'request' ? 'Forgot password' : 'Check inbox'} 
        onBack={handleBack} 
      />

      <Scroll>
        {/* Illustration area */}
        <div style={{
          height: 120,
          marginBottom: 24,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
          {state === 'request' ? (
            // Lock SVG
            <svg width="64" height="64" viewBox="0 0 64 64" style={{ color: 'var(--gz-fg)' }}>
              <rect x="16" y="24" width="32" height="26" rx="4" fill="none" stroke="currentColor" strokeWidth="2"/>
              <path d="M24 24V18a8 8 0 0 1 16 0v6" fill="none" stroke="currentColor" strokeWidth="2"/>
              <circle cx="32" cy="40" r="2.5" fill="currentColor"/>
            </svg>
          ) : (
            // Envelope sent animation
            <svg width="64" height="64" viewBox="0 0 64 64" style={{ color: 'var(--gz-ok)', animation: 'pulse 0.6s ease-out' }}>
              <path d="M12 20h40a4 4 0 0 1 4 4v20a4 4 0 0 1-4 4H12a4 4 0 0 1-4-4V24a4 4 0 0 1 4-4z" fill="none" stroke="currentColor" strokeWidth="2"/>
              <path d="M12 24l20 14 20-14" fill="none" stroke="currentColor" strokeWidth="2"/>
              <path d="M48 20l8-8" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
              <circle cx="52" cy="12" r="6" fill="none" stroke="currentColor" strokeWidth="2"/>
            </svg>
          )}
        </div>

        <style>{`
          @keyframes pulse {
            0% { transform: scale(0.8); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
          }
        `}</style>

        {state === 'request' ? (
          <>
            <h1 className="gz-h1" style={{ marginBottom: 8, textAlign: 'center' }}>Reset your password</h1>
            <p className="gz-body-r" style={{ textAlign: 'center', marginBottom: 20, color: 'var(--gz-fg-2)' }}>
              Enter your registered email and we'll send a reset link. Link expires in 30 minutes.
            </p>

            <input
              autoFocus
              type="email"
              placeholder="your@email.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              style={{
                width: '100%',
                padding: '14px 16px',
                fontSize: 14,
                border: `1px solid var(--gz-rule)`,
                borderRadius: 'var(--gz-r-inner)',
                background: 'var(--gz-card)',
                color: 'var(--gz-fg)',
                marginBottom: 16,
                fontFamily: 'inherit',
              }}
            />

            <button
              onClick={handleSendLink}
              disabled={!isValidEmail}
              className="gz-btn"
              style={{ marginBottom: 12 }}
            >
              Send reset link
            </button>

            <button
              onClick={() => {}}
              style={{
                width: '100%',
                background: 'transparent',
                border: 0,
                color: 'var(--gz-fg)',
                fontSize: 14,
                fontWeight: 600,
                padding: '12px 0',
                textDecoration: 'underline',
                cursor: 'pointer',
                fontFamily: 'inherit',
              }}
            >
              Back to sign in
            </button>

            <div className="gz-small" style={{ marginTop: 20, color: 'var(--gz-fg-3)', textAlign: 'center' }}>
              You can request a new link every 60 seconds
            </div>
          </>
        ) : (
          <>
            <h1 className="gz-h1" style={{ marginBottom: 8, textAlign: 'center' }}>Check your inbox</h1>
            <p className="gz-body-r" style={{ textAlign: 'center', marginBottom: 20, color: 'var(--gz-fg-2)' }}>
              We sent a reset link to <strong style={{ color: 'var(--gz-fg)' }}>{email}</strong>. Check your spam folder if you don't see it.
            </p>

            <button className="gz-btn" style={{ marginBottom: 12 }}>
              Open email app
            </button>

            <button
              onClick={handleResend}
              disabled={countdownSecs > 0}
              style={{
                width: '100%',
                background: 'transparent',
                border: 0,
                color: countdownSecs > 0 ? 'var(--gz-fg-3)' : 'var(--gz-fg)',
                fontSize: 14,
                fontWeight: 600,
                padding: '12px 0',
                textDecoration: countdownSecs > 0 ? 'none' : 'underline',
                cursor: countdownSecs > 0 ? 'default' : 'pointer',
                fontFamily: 'inherit',
              }}
            >
              {countdownSecs > 0 ? `Resend in ${formatCountdown(countdownSecs)}` : 'Resend link'}
            </button>

            <button
              onClick={handleBack}
              style={{
                width: '100%',
                background: 'transparent',
                border: 0,
                color: 'var(--gz-fg)',
                fontSize: 14,
                fontWeight: 500,
                padding: '12px 0',
                cursor: 'pointer',
                fontFamily: 'inherit',
                color: 'var(--gz-fg-2)',
              }}
            >
              Wrong email? Go back
            </button>
          </>
        )}
      </Scroll>

      {showToast && (
        <div style={{
          position: 'fixed',
          bottom: 100,
          left: '50%',
          transform: 'translateX(-50%)',
          background: 'var(--gz-ok)',
          color: 'white',
          padding: '12px 16px',
          borderRadius: 'var(--gz-r-inner)',
          fontSize: 13,
          fontWeight: 600,
          display: 'flex',
          alignItems: 'center',
          gap: 8,
          animation: 'fadeInOut 1.5s ease-out',
        }}>
          ✓ Link resent
        </div>
      )}

      <style>{`
        @keyframes fadeInOut {
          0% { opacity: 0; transform: translateX(-50%) translateY(8px); }
          10% { opacity: 1; transform: translateX(-50%) translateY(0); }
          90% { opacity: 1; }
          100% { opacity: 0; }
        }
      `}</style>
    </Phone>
  );
}

window.ForgotPasswordScreen = ForgotPasswordScreen;
