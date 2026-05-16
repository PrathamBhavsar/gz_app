// Screen 29: Email Login
const { useState, useRef, useEffect } = React;

function EmailLoginScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errorState, setErrorState] = useState(null); // null | 'wrong-password' | 'not-found' | 'not-verified' | 'rate-limit'
  const [rateLimitCountdown, setRateLimitCountdown] = useState(0);
  const emailInputRef = useRef(null);

  useEffect(() => {
    emailInputRef.current?.focus();
  }, []);

  useEffect(() => {
    if (rateLimitCountdown > 0) {
      const timer = setTimeout(() => setRateLimitCountdown(rateLimitCountdown - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [rateLimitCountdown]);

  const isFormValid = email.trim().length > 0 && password.length > 0;
  const isDisabled = !isFormValid || errorState === 'rate-limit';

  const handleSignIn = () => {
    // Simulate error states
    setRateLimitCountdown(0);
    // Cycle through error states for demo
    const states = [null, 'wrong-password', 'not-found', 'not-verified', 'rate-limit'];
    const currentIndex = states.indexOf(errorState);
    const nextIndex = (currentIndex + 1) % states.length;
    const nextState = states[nextIndex];
    setErrorState(nextState);
    if (nextState === 'rate-limit') {
      setRateLimitCountdown(600); // 10 minutes
    }
  };

  const handleResendVerification = () => {
    // Toast would show
    setErrorState(null);
  };

  return (
    <Phone width={390} height={800}>
      <TopBar title="Sign in with email" onBack={() => {}} />
      
      <Scroll>
        <div style={{ paddingTop: 8 }}>
          {/* Heading */}
          <div style={{ marginBottom: 8 }}>
            <h1 className="gz-hero" style={{ fontSize: 28, fontWeight: 700, marginBottom: 8, lineHeight: 1.1 }}>Welcome back</h1>
            <p className="gz-body" style={{ color: 'var(--gz-fg-2)', margin: 0 }}>Sign in with your email and password</p>
          </div>

          {/* Email field */}
          <div style={{ marginTop: 24, marginBottom: 16 }}>
            <input
              ref={emailInputRef}
              type="email"
              placeholder="your@email.com"
              value={email}
              onChange={(e) => {
                setEmail(e.target.value);
                if (errorState === 'not-found' || errorState === 'not-verified') {
                  setErrorState(null);
                }
              }}
              style={{
                width: '100%', padding: '12px 16px',
                fontSize: 16, fontFamily: 'inherit', border: 0,
                borderRadius: 12,
                background: 'var(--gz-pill)',
                color: 'var(--gz-fg)',
                outline: 'none',
                boxShadow: errorState === 'not-found' || errorState === 'not-verified' ? 'inset 0 0 0 1.5px var(--gz-err)' : 'none',
                transition: 'box-shadow 0.2s',
              }}
            />
          </div>

          {/* Email error banner */}
          {errorState === 'not-verified' && (
            <div style={{
              background: 'var(--gz-warn)', color: 'var(--gz-fg)',
              padding: '12px 16px', borderRadius: 8, marginBottom: 16,
              fontSize: 13, lineHeight: 1.4, display: 'flex', justifyContent: 'space-between', alignItems: 'center',
            }}>
              <span>Email not verified — check your inbox or resend verification</span>
              <button onClick={handleResendVerification} style={{
                background: 'transparent', border: 0, color: 'var(--gz-fg)', fontWeight: 600,
                cursor: 'pointer', textDecoration: 'underline', padding: 0, marginLeft: 8,
              }}>Resend →</button>
            </div>
          )}

          {/* Password field */}
          <div style={{ marginBottom: 8, position: 'relative' }}>
            <input
              type={showPassword ? 'text' : 'password'}
              placeholder="Your password"
              value={password}
              onChange={(e) => {
                setPassword(e.target.value);
                if (errorState === 'wrong-password') {
                  setErrorState(null);
                }
              }}
              style={{
                width: '100%', padding: '12px 16px 12px 16px', paddingRight: 44,
                fontSize: 16, fontFamily: 'inherit', border: 0,
                borderRadius: 12,
                background: 'var(--gz-pill)',
                color: 'var(--gz-fg)',
                outline: 'none',
                boxShadow: errorState === 'wrong-password' ? 'inset 0 0 0 1.5px var(--gz-err)' : 'none',
                transition: 'box-shadow 0.2s',
              }}
            />
            <button
              onClick={() => setShowPassword(!showPassword)}
              style={{
                position: 'absolute', right: 12, top: '50%', transform: 'translateY(-50%)',
                background: 'transparent', border: 0, width: 38, height: 38,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: 'var(--gz-fg-3)', cursor: 'pointer', padding: 0,
              }}
            >
              <svg viewBox="0 0 24 24" style={{ width: 18, height: 18, stroke: 'currentColor', fill: 'none', strokeWidth: 2 }}>
                {showPassword ? (
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

          {/* Password error */}
          {errorState === 'wrong-password' && (
            <p style={{ color: 'var(--gz-err)', fontSize: 12, marginBottom: 16, margin: '8px 0 16px' }}>
              Incorrect password. Try again or reset it.
            </p>
          )}

          {/* Forgot password link */}
          <button onClick={() => {}}
            style={{
              display: 'block', marginLeft: 'auto', marginBottom: 24,
              background: 'transparent', border: 0, color: 'var(--gz-fg)',
              fontSize: 13, fontWeight: 600, cursor: 'pointer', textDecoration: 'none', padding: 0,
            }}>
            Forgot password? →
          </button>

          {/* Rate limit banner */}
          {errorState === 'rate-limit' && (
            <div style={{
              background: 'var(--gz-warn)', color: 'var(--gz-fg)',
              padding: '12px 16px', borderRadius: 8, marginBottom: 16,
              fontSize: 13, fontWeight: 600, textAlign: 'center',
            }}>
              Too many attempts. Try again in {Math.floor(rateLimitCountdown / 60)}:{String(rateLimitCountdown % 60).padStart(2, '0')}
            </div>
          )}

          {/* Account not found error */}
          {errorState === 'not-found' && (
            <p style={{ color: 'var(--gz-err)', fontSize: 13, marginBottom: 16, margin: '0 0 16px' }}>
              No account found with this email. Create one →
            </p>
          )}

          {/* Sign in button */}
          <Button 
            onClick={handleSignIn} 
            disabled={isDisabled}
            style={{
              marginBottom: 24,
              background: isDisabled ? 'var(--gz-fg-4)' : 'var(--gz-ok)',
              color: isDisabled ? 'var(--gz-fg-3)' : 'var(--gz-fg)',
            }}
          >
            Sign in
          </Button>

          {/* Divider */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
            <div style={{ flex: 1, height: 1, background: 'var(--gz-rule)' }} />
            <span className="gz-body-r" style={{ color: 'var(--gz-fg-3)' }}>or</span>
            <div style={{ flex: 1, height: 1, background: 'var(--gz-rule)' }} />
          </div>

          {/* Phone OTP button */}
          <Button onClick={() => {}} variant="ghost">
            {React.cloneElement(I.phone, { style: { width: 18, height: 18 } })}
            Use phone OTP instead
          </Button>
        </div>
      </Scroll>
    </Phone>
  );
}

Object.assign(window, { EmailLoginScreen });
