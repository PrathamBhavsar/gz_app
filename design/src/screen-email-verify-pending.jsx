// Screen 30: Email Verify Pending
const { useState, useEffect } = React;

function EmailVerifyPendingScreen() {
  const [resendCountdown, setResendCountdown] = useState(0);
  const [verificationChecked, setVerificationChecked] = useState(false);
  const [verificationResult, setVerificationResult] = useState(null); // null | 'success' | 'pending'
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (resendCountdown > 0) {
      const timer = setTimeout(() => setResendCountdown(resendCountdown - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [resendCountdown]);

  const handleResend = () => {
    setResendCountdown(58);
    // Toast would show "Sent! Check your inbox ✓"
  };

  const handleVerified = () => {
    setIsLoading(true);
    setVerificationChecked(true);
    setTimeout(() => {
      setVerificationResult('pending'); // Change to 'success' for success state
      setIsLoading(false);
    }, 800);
  };

  return (
    <Phone width={390} height={800}>
      {/* Close button header */}
      <div style={{ padding: '8px 16px 12px', display: 'flex', justifyContent: 'flex-end', flexShrink: 0 }}>
        <button onClick={() => {}} style={{
          width: 38, height: 38, border: 0, background: 'transparent',
          color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 0,
        }}>
          {I.x}
        </button>
      </div>

      <Scroll pad={false}>
        <div style={{ display: 'flex', flexDirection: 'column', height: '100%', padding: '16px', paddingTop: 0 }}>
          {/* Envelope illustration */}
          <div style={{ flex: '0 0 40%', display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: 24 }}>
            <svg width="140" height="120" viewBox="0 0 140 120" style={{
              animation: 'envelope-float 3s ease-in-out infinite',
            }}>
              <style>{`
                @keyframes envelope-float {
                  0%, 100% { transform: translateY(0px); }
                  50% { transform: translateY(-12px); }
                }
                @keyframes paper-float {
                  0% { transform: translateX(20px) translateY(10px) rotate(-5deg); opacity: 0; }
                  30% { opacity: 1; }
                  100% { transform: translateX(80px) translateY(-60px) rotate(15deg); opacity: 0; }
                }
              `}</style>

              {/* Envelope body */}
              <rect x="10" y="30" width="100" height="70" rx="4" fill="none" stroke="var(--gz-fg)" strokeWidth="2" />
              {/* Envelope flap */}
              <path d="M 10 30 L 60 60 L 110 30" fill="none" stroke="var(--gz-fg)" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
              {/* Envelope fold line */}
              <path d="M 60 30 L 60 100" stroke="var(--gz-rule)" strokeWidth="1" />

              {/* Flying paper plane - animated */}
              <g style={{ animation: 'paper-float 2.5s ease-out infinite' }}>
                <path d="M 30 50 L 50 45 L 35 65 Z" fill="var(--gz-fg-2)" />
                <path d="M 35 60 L 50 45 L 40 70 Z" fill="var(--gz-fg-3)" opacity="0.6" />
              </g>
            </svg>
          </div>

          {/* Content */}
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
            <h1 className="gz-hero" style={{ fontSize: 24, fontWeight: 700, marginBottom: 8, lineHeight: 1.2 }}>
              Verify your email
            </h1>

            <p className="gz-body" style={{ color: 'var(--gz-fg-2)', marginBottom: 16, lineHeight: 1.5 }}>
              We sent a verification link to <br />
              <span style={{ fontWeight: 600, color: 'var(--gz-fg)' }}>pratham@gmail.com</span>
              <br />
              Click the link to activate your account
            </p>

            <p className="gz-body-r" style={{ color: 'var(--gz-fg-3)', marginBottom: 24, fontSize: 12 }}>
              Can't find it? Check your spam or promotions folder
            </p>

            {/* Resend button with countdown */}
            <Button 
              onClick={handleResend} 
              disabled={resendCountdown > 0} 
              variant="ghost" 
              style={{ marginBottom: 16 }}
            >
              {resendCountdown > 0 ? `Resend in 0:${String(resendCountdown).padStart(2, '0')}` : 'Resend verification email'}
            </Button>

            {/* Verified check button */}
            <Button 
              onClick={handleVerified} 
              disabled={isLoading || verificationResult === 'success'}
              style={{
                marginBottom: 16,
                background: isLoading ? 'var(--gz-fg-4)' : (verificationResult === 'success' ? 'var(--gz-ok)' : 'var(--gz-btn)'),
              }}
            >
              {isLoading && (
                <span style={{ display: 'inline-block', animation: 'spin 1s linear infinite', width: 16, height: 16 }}>
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="12" cy="12" r="10" style={{ opacity: 0.3 }} />
                    <path d="M12 2a10 10 0 0 1 10 10" style={{ strokeLinecap: 'round' }} />
                  </svg>
                </span>
              )}
              {verificationResult === 'success' ? (
                <>
                  {React.cloneElement(I.check, { style: { width: 18, height: 18 } })}
                  Verified!
                </>
              ) : (
                "I've verified — continue →"
              )}
            </Button>

            {/* Verification pending error */}
            {verificationResult === 'pending' && (
              <p style={{ color: 'var(--gz-err)', fontSize: 12, marginBottom: 16, padding: '8px 0' }}>
                Still not verified. Try clicking the link in your email.
              </p>
            )}

            {/* Bottom links */}
            <div style={{ marginTop: 'auto', paddingTop: 16, borderTop: '1px solid var(--gz-rule)' }}>
              <button onClick={() => {}} style={{
                display: 'block', width: '100%', textAlign: 'center',
                background: 'transparent', border: 0, color: 'var(--gz-fg)',
                fontSize: 13, fontWeight: 600, cursor: 'pointer', padding: '12px 0',
              }}>
                Wrong email? Change it →
              </button>
              <p className="gz-body-r" style={{ color: 'var(--gz-fg-3)', fontSize: 11, textAlign: 'center', margin: '8px 0 0' }}>
                Having trouble? Contact support
              </p>
            </div>
          </div>
        </div>

        <style>{`
          @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
          }
        `}</style>
      </Scroll>
    </Phone>
  );
}

Object.assign(window, { EmailVerifyPendingScreen });
