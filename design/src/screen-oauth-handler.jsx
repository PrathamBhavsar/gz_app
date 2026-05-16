// Screen 31: OAuth Handler
const { useState, useEffect } = React;

function OAuthHandlerScreen() {
  const [provider, setProvider] = useState('google'); // 'google' | 'apple'
  const [showError, setShowError] = useState(false);
  const [showTakingTooLong, setShowTakingTooLong] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setShowTakingTooLong(true), 5000);
    return () => clearTimeout(timer);
  }, []);

  return (
    <Phone width={390} height={800}>
      <Scroll pad={false}>
        <div style={{
          display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
          height: '100%', padding: '40px 24px', textAlign: 'center',
        }}>
          {!showError ? (
            <>
              {/* App logo */}
              <div style={{
                width: 64, height: 64, marginBottom: 32,
                background: 'var(--gz-card-tint)', borderRadius: 16,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: 'var(--gz-font)', fontSize: 28, fontWeight: 700, color: 'var(--gz-fg)',
              }}>
                GZ
              </div>

              {/* Connecting visual - Walle-inspired avatars */}
              <div style={{ marginBottom: 32, position: 'relative', width: 200, height: 80, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                {/* Left circle - GZ logo */}
                <div style={{ animation: 'pulse-left 2s ease-in-out infinite' }}>
                  <Avatar size="xl" index={0}>GZ</Avatar>
                </div>

                {/* Connecting dots */}
                <div style={{ display: 'flex', gap: 8, margin: '0 16px', alignItems: 'center' }}>
                  <div style={{ 
                    width: 6, 
                    height: 6, 
                    borderRadius: '50%', 
                    background: 'var(--gz-fg-3)',
                    animation: 'dot-pulse 1.5s ease-in-out infinite'
                  }} />
                  <div style={{ 
                    width: 6, 
                    height: 6, 
                    borderRadius: '50%', 
                    background: 'var(--gz-fg-3)',
                    animation: 'dot-pulse 1.5s ease-in-out infinite 0.2s'
                  }} />
                  <div style={{ 
                    width: 6, 
                    height: 6, 
                    borderRadius: '50%', 
                    background: 'var(--gz-fg-3)',
                    animation: 'dot-pulse 1.5s ease-in-out infinite 0.4s'
                  }} />
                </div>

                {/* Right circle - provider logo */}
                <div style={{ animation: 'pulse-right 2s ease-in-out infinite 0.3s' }}>
                  <Avatar size="xl" index={provider === 'google' ? 4 : 5}>
                    {provider === 'google' ? 'G' : ''}
                  </Avatar>
                </div>

                <style>{`
                  @keyframes pulse-left {
                    0%, 100% { transform: scale(1); }
                    50% { transform: scale(1.1); }
                  }
                  @keyframes pulse-right {
                    0%, 100% { transform: scale(1); }
                    50% { transform: scale(1.1); }
                  }
                  @keyframes dot-pulse {
                    0%, 100% { opacity: 0.3; }
                    50% { opacity: 1; }
                  }
                `}</style>
              </div>

              {/* Text */}
              <h1 className="gz-hero" style={{ fontSize: 20, fontWeight: 700, marginBottom: 8 }}>
                Connecting with {provider === 'google' ? 'Google' : 'Apple'}
              </h1>

              <p className="gz-body" style={{ color: 'var(--gz-fg-2)', marginBottom: 8 }}>
                Hang tight, we're setting up your account...
              </p>

              <p className="gz-body-r" style={{ color: 'var(--gz-fg-3)', fontSize: 12 }}>
                This usually takes a few seconds
              </p>

              {/* Taking too long message */}
              {showTakingTooLong && (
                <button onClick={() => {}}
                  style={{
                    marginTop: 32, background: 'transparent', border: 0,
                    color: 'var(--gz-fg)', fontSize: 13, fontWeight: 600,
                    cursor: 'pointer', textDecoration: 'none', padding: 0,
                  }}>
                  Taking too long? Cancel and try again →
                </button>
              )}

              {/* Provider toggle for demo */}
              <div style={{ marginTop: 40, display: 'flex', gap: 12 }}>
                <button onClick={() => setProvider('google')} style={{
                  padding: '8px 16px', fontSize: 12, fontWeight: 600, border: '1px solid var(--gz-rule)',
                  borderRadius: 8, background: provider === 'google' ? 'var(--gz-ok)' : 'transparent',
                  color: 'var(--gz-fg)', cursor: 'pointer',
                }}>
                  Google
                </button>
                <button onClick={() => setProvider('apple')} style={{
                  padding: '8px 16px', fontSize: 12, fontWeight: 600, border: '1px solid var(--gz-rule)',
                  borderRadius: 8, background: provider === 'apple' ? 'var(--gz-ok)' : 'transparent',
                  color: 'var(--gz-fg)', cursor: 'pointer',
                }}>
                  Apple
                </button>
                <button onClick={() => setShowError(!showError)} style={{
                  padding: '8px 16px', fontSize: 12, fontWeight: 600, border: '1px solid var(--gz-rule)',
                  borderRadius: 8, background: showError ? 'var(--gz-err)' : 'transparent',
                  color: 'var(--gz-fg)', cursor: 'pointer',
                }}>
                  Error
                </button>
              </div>
            </>
          ) : (
            <>
              {/* Error state */}
              <div style={{ marginBottom: 32 }}>
                <Avatar size="xl" index={3} icon={
                  <svg viewBox="0 0 24 24" style={{ stroke: 'currentColor', fill: 'none', strokeWidth: 2 }}>
                    <path d="M6 6l12 12M18 6L6 18"/>
                  </svg>
                } />
              </div>

              <h1 className="gz-hero" style={{ fontSize: 20, fontWeight: 700, marginBottom: 8 }}>
                Couldn't connect with {provider === 'google' ? 'Google' : 'Apple'}
              </h1>

              <p className="gz-body" style={{ color: 'var(--gz-fg-2)', marginBottom: 24 }}>
                Something went wrong. Your account was not created.
              </p>

              {/* Action buttons */}
              <Button onClick={() => setShowError(false)} style={{ marginBottom: 12, background: 'var(--gz-ok)' }}>
                Try again
              </Button>

              <Button onClick={() => {}} variant="ghost">
                Use a different method →
              </Button>

              {/* Provider toggle for demo */}
              <div style={{ marginTop: 32, display: 'flex', gap: 12 }}>
                <button onClick={() => setProvider('google')} style={{
                  padding: '8px 16px', fontSize: 12, fontWeight: 600, border: '1px solid var(--gz-rule)',
                  borderRadius: 8, background: provider === 'google' ? 'var(--gz-ok)' : 'transparent',
                  color: 'var(--gz-fg)', cursor: 'pointer',
                }}>
                  Google
                </button>
                <button onClick={() => setProvider('apple')} style={{
                  padding: '8px 16px', fontSize: 12, fontWeight: 600, border: '1px solid var(--gz-rule)',
                  borderRadius: 8, background: provider === 'apple' ? 'var(--gz-ok)' : 'transparent',
                  color: 'var(--gz-fg)', cursor: 'pointer',
                }}>
                  Apple
                </button>
                <button onClick={() => setShowError(!showError)} style={{
                  padding: '8px 16px', fontSize: 12, fontWeight: 600, border: '1px solid var(--gz-rule)',
                  borderRadius: 8, background: showError ? 'var(--gz-err)' : 'transparent',
                  color: 'var(--gz-fg)', cursor: 'pointer',
                }}>
                  Connecting
                </button>
              </div>
            </>
          )}
        </div>
      </Scroll>
    </Phone>
  );
}

Object.assign(window, { OAuthHandlerScreen });
