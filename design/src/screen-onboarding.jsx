// Screen 20 — Onboarding Screen
// First-ever launch. 4 swipeable feature cards. Sets tone for entire app.

function OnboardingScreen() {
  const [cardIdx, setCardIdx] = useState(0);
  const totalCards = 4;

  const cards = [
    {
      headline: 'Book your gaming slot in seconds',
      subtext: 'Find nearby gaming cafes, pick your system, confirm in 3 taps.',
      cta: 'Next →',
      illustration: (
        <div style={{
          width: '100%', height: '100%',
          background: `linear-gradient(135deg, #DDE9D2 0%, #C7DDB8 100%)`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          position: 'relative', overflow: 'hidden',
        }}>
          {/* Geometric gaming scene - CSS shapes */}
          <svg width="200" height="200" viewBox="0 0 200 200" style={{ position: 'absolute' }}>
            {/* Grid background */}
            <defs>
              <pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse">
                <path d="M 20 0 L 0 0 0 20" fill="none" stroke="rgba(10,10,10,0.08)" strokeWidth="0.5"/>
              </pattern>
            </defs>
            <rect width="200" height="200" fill="url(#grid)" />

            {/* Main shapes */}
            <circle cx="100" cy="80" r="35" fill="rgba(10,10,10,0.15)" />
            <rect x="60" y="120" width="80" height="50" rx="8" fill="none" stroke="rgba(10,10,10,0.2)" strokeWidth="2" />
            <circle cx="80" cy="100" r="12" fill="#0A0A0A" opacity="0.3" />
            <circle cx="120" cy="100" r="12" fill="#0A0A0A" opacity="0.3" />

            {/* Accent elements */}
            <path d="M 50 40 L 150 40 L 150 60 L 50 60 Z" fill="rgba(199, 221, 184, 0.6)" />
            <circle cx="40" cy="160" r="18" fill="none" stroke="rgba(10,10,10,0.15)" strokeWidth="2" />
            <circle cx="160" cy="150" r="25" fill="none" stroke="rgba(10,10,10,0.1)" strokeWidth="2" />
          </svg>
        </div>
      ),
    },
    {
      headline: 'Earn credits every session',
      subtext: 'Play more, earn more. Redeem credits for discounts on future bookings.',
      cta: 'Next →',
      illustration: (
        <div style={{
          width: '100%', height: '100%',
          background: `linear-gradient(135deg, #E5DCEE 0%, #DCE3F2 100%)`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          position: 'relative', overflow: 'hidden',
        }}>
          {/* Credits/coins theme */}
          <svg width="180" height="180" viewBox="0 0 180 180" style={{ position: 'absolute' }}>
            {/* Large coin */}
            <circle cx="90" cy="90" r="50" fill="none" stroke="rgba(10,10,10,0.2)" strokeWidth="3" />
            <circle cx="90" cy="90" r="45" fill="rgba(10,10,10,0.05)" />
            <text x="90" y="100" fontSize="32" fontWeight="700" textAnchor="middle" fill="rgba(10,10,10,0.3)" fontFamily="monospace">₹</text>

            {/* Orbiting coins */}
            <g transform="translate(90, 90)">
              <circle cx="0" cy="-70" r="18" fill="rgba(199, 221, 184, 0.4)" />
              <circle cx="60" cy="40" r="16" fill="rgba(220, 227, 242, 0.4)" />
              <circle cx="-60" cy="40" r="14" fill="rgba(221, 239, 217, 0.4)" />
            </g>

            {/* Stars */}
            <path d="M 30 30 L 32 36 L 38 36 L 33 40 L 35 46 L 30 42 L 25 46 L 27 40 L 22 36 L 28 36 Z" fill="rgba(10,10,10,0.15)" />
            <path d="M 150 40 L 151 43 L 154 43 L 151 45 L 152 48 L 150 46 L 148 48 L 149 45 L 146 43 L 149 43 Z" fill="rgba(10,10,10,0.1)" />
            <path d="M 20 130 L 22 135 L 28 135 L 23 139 L 25 144 L 20 140 L 15 144 L 17 139 L 12 135 L 18 135 Z" fill="rgba(10,10,10,0.12)" />
          </svg>
        </div>
      ),
    },
    {
      headline: 'Track your session live',
      subtext: 'Real-time countdown, live cost tracker, and instant alerts when time\'s running low.',
      cta: 'Next →',
      illustration: (
        <div style={{
          width: '100%', height: '100%',
          background: `linear-gradient(135deg, #F6E6C8 0%, #DDE9D2 100%)`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          position: 'relative', overflow: 'hidden',
        }}>
          {/* Live timer / session theme */}
          <svg width="200" height="200" viewBox="0 0 200 200" style={{ position: 'absolute' }}>
            {/* Clock circle */}
            <circle cx="100" cy="100" r="60" fill="none" stroke="rgba(10,10,10,0.15)" strokeWidth="3" />
            <circle cx="100" cy="100" r="55" fill="rgba(10,10,10,0.03)" />

            {/* Clock markers */}
            {[0, 1, 2, 3].map(i => {
              const angle = (i / 4) * Math.PI * 2;
              const x1 = 100 + 55 * Math.cos(angle);
              const y1 = 100 + 55 * Math.sin(angle);
              const x2 = 100 + 50 * Math.cos(angle);
              const y2 = 100 + 50 * Math.sin(angle);
              return <line key={i} x1={x1} y1={y1} x2={x2} y2={y2} stroke="rgba(10,10,10,0.2)" strokeWidth="2" />;
            })}

            {/* Hour hand */}
            <line x1="100" y1="100" x2="100" y2="65" stroke="rgba(10,10,10,0.25)" strokeWidth="3" strokeLinecap="round" />
            {/* Minute hand */}
            <line x1="100" y1="100" x2="100" y2="50" stroke="rgba(10,10,10,0.35)" strokeWidth="2" strokeLinecap="round" />
            {/* Center dot */}
            <circle cx="100" cy="100" r="5" fill="rgba(10,10,10,0.3)" />

            {/* Pulsing indicator */}
            <circle cx="100" cy="45" r="8" fill="rgba(46, 122, 60, 0.4)" opacity="0.7" />

            {/* Wave lines (activity) */}
            <path d="M 130 140 Q 145 130 160 140" fill="none" stroke="rgba(10,10,10,0.12)" strokeWidth="1.5" strokeLinecap="round" />
            <path d="M 130 155 Q 145 145 160 155" fill="none" stroke="rgba(10,10,10,0.1)" strokeWidth="1.5" strokeLinecap="round" />
          </svg>
        </div>
      ),
    },
    {
      headline: 'Your gaming history, all in one place',
      subtext: 'Every session, every booking, every receipt. Organized and searchable.',
      cta: 'Get Started →',
      ctaPrimary: true,
      showSecondary: true,
    },
  ];

  const card = cards[cardIdx];
  const showIllustration = card.illustration;

  const handleNext = () => {
    if (cardIdx < totalCards - 1) {
      setCardIdx(cardIdx + 1);
    }
  };

  const handleSkip = () => {
    setCardIdx(totalCards - 1);
  };

  const handleGetStarted = () => {
    // Navigate to auth
  };

  return (
    <Phone>
      {/* Skip link (top-left) */}
      {cardIdx < totalCards - 1 && (
        <button
          onClick={handleSkip}
          style={{
            position: 'absolute', top: 16, left: 16, zIndex: 10,
            background: 'transparent', border: 0, color: 'var(--gz-fg-3)',
            fontSize: 14, fontWeight: 500, cursor: 'pointer', padding: '8px 12px',
          }}>
          Skip
        </button>
      )}

      {/* Progress dots (top-right) */}
      <div style={{
        position: 'absolute', top: 16, right: 16, zIndex: 10,
        display: 'flex', gap: 6,
      }}>
        {Array.from({ length: totalCards }).map((_, i) => (
          <button
            key={i}
            onClick={() => setCardIdx(i)}
            style={{
              width: i === cardIdx ? 24 : 8,
              height: 8, borderRadius: 999,
              background: i === cardIdx ? 'var(--gz-fg)' : 'var(--gz-rule)',
              border: 0, cursor: 'pointer',
              transition: 'all 0.3s ease',
            }}
          />
        ))}
      </div>

      {/* Card container */}
      <div style={{
        display: 'flex', flexDirection: 'column', height: '100%',
        overflow: 'hidden', animation: `fadeIn 0.4s ease-out`,
      }}>
        {/* Illustration area (55%) */}
        {showIllustration && (
          <div style={{
            flex: '0 0 55%',
            background: 'var(--gz-card)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            animation: `slideUp 0.5s cubic-bezier(0.2, 0.7, 0.3, 1)`,
          }}>
            {card.illustration}
          </div>
        )}

        {/* Content area (45%) */}
        <div style={{
          flex: '1 0 auto',
          display: 'flex', flexDirection: 'column',
          padding: '32px 24px 24px',
          justifyContent: 'space-between',
        }}>
          <div>
            <h1 className="gz-title" style={{ marginBottom: 12, lineHeight: 1.25 }}>
              {card.headline}
            </h1>
            <p className="gz-body-r" style={{ marginBottom: 0, lineHeight: 1.6 }}>
              {card.subtext}
            </p>
          </div>

          {/* CTAs */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {cardIdx === totalCards - 1 ? (
              <>
                <button
                  onClick={handleGetStarted}
                  style={{
                    width: '100%', padding: '16px 22px',
                    background: 'var(--gz-btn)', color: 'var(--gz-btn-fg)',
                    border: 0, borderRadius: 16,
                    fontSize: 15, fontWeight: 600, cursor: 'pointer',
                  }}>
                  Get Started →
                </button>
                <button
                  onClick={() => {}}
                  style={{
                    width: '100%', padding: '12px',
                    background: 'transparent', border: 0,
                    color: 'var(--gz-fg-2)', fontSize: 14, fontWeight: 600,
                    cursor: 'pointer',
                  }}>
                  I already have an account
                </button>
              </>
            ) : (
              <button
                onClick={handleNext}
                style={{
                  width: '100%', padding: '16px 22px',
                  background: 'var(--gz-btn)', color: 'var(--gz-btn-fg)',
                  border: 0, borderRadius: 16,
                  fontSize: 15, fontWeight: 600, cursor: 'pointer',
                }}>
                {card.cta}
              </button>
            )}
          </div>
        </div>
      </div>

      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slideUp {
          from { transform: translateY(20px); opacity: 0; }
          to { transform: translateY(0); opacity: 1; }
        }
      `}</style>
    </Phone>
  );
}

Object.assign(window, { OnboardingScreen });
