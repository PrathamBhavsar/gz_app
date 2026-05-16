// Screen 17 — Check-In Screen
// Player arriving at the venue. QR code + self-service check-in. Time-pressured screen.

function CheckInScreen() {
  const [checkedIn, setCheckedIn] = useState(false);
  const [loading, setLoading] = useState(false);
  const [countdown, setCountdown] = useState(754); // 12:34 in seconds
  const [inWindow, setInWindow] = useState(true); // true = green, false amber, null = red

  useEffect(() => {
    const interval = setInterval(() => {
      setCountdown(c => {
        if (c <= 0) {
          setInWindow(false);
          return 0;
        }
        return c - 1;
      });
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  const mins = Math.floor(countdown / 60);
  const secs = countdown % 60;

  const handleTapCheckin = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setCheckedIn(true);
    }, 1500);
  };

  const bannerColor = inWindow ? 'var(--gz-ok)' : 'var(--gz-warn)';
  const bannerBg = inWindow ? 'var(--gz-ok-bg)' : 'var(--gz-warn-bg)';

  if (checkedIn) {
    return (
      <Phone>
        <TopBar title="Check in" onBack={() => setCheckedIn(false)} />
        <Scroll pad={false}>
          <div style={{ padding: '20px 16px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: 400 }}>
            {/* Checkmark animation */}
            <div style={{
              width: 80, height: 80, borderRadius: 999,
              background: 'var(--gz-ok-bg)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              marginBottom: 24,
              animation: 'pulse-scale 0.6s ease-out',
            }}>
              <svg width="40" height="40" viewBox="0 0 24 24" style={{ stroke: 'var(--gz-ok)', strokeWidth: 2.5, fill: 'none', strokeLinecap: 'round' }}>
                <path d="M5 12l5 5L20 7" />
              </svg>
            </div>
            <div className="gz-title" style={{ textAlign: 'center', marginBottom: 8 }}>Checked in! ✓</div>
            <div className="gz-body-r" style={{ textAlign: 'center', marginBottom: 24 }}>Your session starts now</div>
            <button className="gz-btn" onClick={() => setCheckedIn(false)} style={{ width: 'auto', paddingLeft: 20, paddingRight: 20 }}>
              View session →
            </button>
          </div>
        </Scroll>
        <style>{`
          @keyframes pulse-scale {
            0% { transform: scale(0.8); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
          }
        `}</style>
      </Phone>
    );
  }

  return (
    <Phone>
      <TopBar title="Check in" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '16px 16px 20px' }}>
          {/* Booking context card */}
          <div className="gz-card" style={{ marginBottom: 16 }}>
            <div className="gz-body" style={{ fontWeight: 600, marginBottom: 8 }}>GameZone Koramangala</div>
            <div className="gz-small" style={{ color: 'var(--gz-fg-2)', marginBottom: 4 }}>RTX 4090 · Seat 3</div>
            <div className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>Today 4:00 PM – 6:00 PM</div>
          </div>

          {/* Check-in window banner */}
          <div style={{
            background: bannerBg,
            border: `1px solid ${bannerColor}`,
            borderRadius: 16,
            padding: 14,
            marginBottom: 20,
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <span style={{ color: bannerColor, flexShrink: 0 }}>
              {React.cloneElement(I.clock, { style: { width: 20, height: 20 } })}
            </span>
            <div style={{ flex: 1 }}>
              <div className="gz-small" style={{ color: bannerColor, fontWeight: 600 }}>
                Check-in window: 3:45 PM – 4:15 PM
              </div>
            </div>
          </div>

          {/* Countdown */}
          <div style={{ textAlign: 'center', marginBottom: 24 }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 6 }}>Check-in closes in</div>
            <div className="gz-hero" style={{
              fontSize: 48,
              color: inWindow ? 'var(--gz-fg)' : 'var(--gz-warn)',
            }}>
              {String(mins).padStart(2, '0')}:{String(secs).padStart(2, '0')}
            </div>
          </div>

          {/* QR code block */}
          <div style={{
            background: 'var(--gz-card)',
            border: `2px solid var(--gz-rule)`,
            borderRadius: 20,
            padding: 20,
            marginBottom: 20,
            textAlign: 'center',
          }}>
            {/* Simple QR placeholder */}
            <div style={{
              width: 160, height: 160,
              margin: '0 auto 14px',
              background: `
                linear-gradient(45deg, #000 0%, #000 25%, transparent 25%),
                linear-gradient(-45deg, #000 0%, #000 25%, transparent 25%),
                linear-gradient(45deg, transparent 75%, #000 75%),
                linear-gradient(-45deg, transparent 75%, #000 75%)
              `,
              backgroundSize: '20px 20px',
              backgroundPosition: '0 0, 0 10px, 10px -10px, -10px 0px',
              borderRadius: 12,
            }} />
            <div className="gz-body" style={{ fontWeight: 600, marginBottom: 8 }}>Show this to staff</div>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', fontFamily: 'var(--gz-mono)' }}>BKG-20948</div>
          </div>

          {/* Divider */}
          <div style={{ textAlign: 'center', marginBottom: 20 }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>or</div>
          </div>

          {/* Self-service button */}
          <button
            onClick={handleTapCheckin}
            disabled={loading}
            style={{
              width: '100%', padding: '16px 20px',
              background: loading ? 'var(--gz-fg-3)' : 'var(--gz-btn)',
              color: 'var(--gz-btn-fg)',
              border: 0, borderRadius: 16,
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
              fontSize: 15, fontWeight: 600,
              cursor: loading ? 'default' : 'pointer',
              opacity: loading ? 0.6 : 1,
              marginBottom: 24,
            }}>
            {loading ? (
              <span style={{ display: 'inline-block', animation: 'spin 0.8s linear infinite', width: 18, height: 18 }}>
                ⟳
              </span>
            ) : (
              <>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                  <circle cx="12" cy="12" r="2"/>
                  <path d="M9 2a3 3 0 110 6 3 3 0 010-6zm0 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
                Tap to check in
              </>
            )}
          </button>

          {/* Bottom note */}
          <div style={{ textAlign: 'center', paddingBottom: 20 }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', lineHeight: 1.5 }}>
              Having trouble? Ask staff to scan your booking ID: <span style={{ fontFamily: 'var(--gz-mono)', fontWeight: 600 }}>BKG-20948</span>
            </div>
          </div>
        </div>
      </Scroll>
      <style>{`
        @keyframes spin {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }
      `}</style>
    </Phone>
  );
}

Object.assign(window, { CheckInScreen });
