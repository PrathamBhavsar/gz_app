function EmailVerifySuccessScreen() {
  const [countdown, setCountdown] = React.useState(4);
  const [autoAdvanceActive, setAutoAdvanceActive] = React.useState(true);

  React.useEffect(() => {
    if (!autoAdvanceActive) return;
    const timer = setInterval(() => {
      setCountdown(prev => prev > 0 ? prev - 1 : 0);
    }, 1000);
    return () => clearInterval(timer);
  }, [autoAdvanceActive]);

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      height: '100%',
      background: 'radial-gradient(circle at center, rgba(217,119,87,0.1) 0%, rgba(0,0,0,0) 70%), linear-gradient(135deg, #1a1a1a 0%, #2d2a26 50%, #3a3530 100%)',
      alignItems: 'center',
      justifyContent: 'center',
      position: 'relative',
      overflow: 'hidden'
    }}>
      {/* Animated checkmark circle */}
      <div style={{
        width: 120,
        height: 120,
        borderRadius: '50%',
        background: 'var(--gz-ok)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: 56,
        color: '#fff',
        marginBottom: 32,
        animation: 'checkmarkPop 0.6s cubic-bezier(0.34,1.56,0.64,1) 0.2s both'
      }}>
        ✓
      </div>

      {/* Confetti particles */}
      <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }}>
        {[...Array(30)].map((_, i) => (
          <div
            key={i}
            style={{
              position: 'absolute',
              width: 8,
              height: 8,
              borderRadius: '50%',
              background: ['var(--gz-ok)', '#D97757', '#E5A573', '#DDE9D2'][i % 4],
              left: `${Math.random() * 100}%`,
              top: '-20px',
              animation: `confetti${i % 3} 1.5s ease-out 0.3s forwards`,
              opacity: 0.8
            }}
          />
        ))}
      </div>

      {/* Content */}
      <div style={{ textAlign: 'center', zIndex: 1 }}>
        <div style={{
          fontSize: 28,
          fontWeight: 700,
          color: '#fff',
          marginBottom: 12,
          animation: 'fadeInUp 0.6s ease-out 0.4s both'
        }}>
          Email verified!
        </div>

        <div style={{
          fontSize: 14,
          color: '#ccc',
          marginBottom: 8,
          animation: 'fadeInUp 0.6s ease-out 0.5s both'
        }}>
          pratham@gmail.com is now confirmed
        </div>

        <div style={{
          fontSize: 12,
          color: '#999',
          marginBottom: 32,
          animation: 'fadeInUp 0.6s ease-out 0.6s both'
        }}>
          Your account is fully set up. Welcome to Gaming Zone.
        </div>

        {/* CTAs */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, animation: 'fadeInUp 0.6s ease-out 0.7s both' }}>
          <button
            onClick={() => setAutoAdvanceActive(false)}
            style={{
              width: '100%',
              padding: '12px',
              background: '#D97757',
              color: '#fff',
              border: 'none',
              borderRadius: 8,
              fontWeight: 600,
              fontSize: 14,
              cursor: 'pointer',
              transition: 'all 0.2s ease'
            }}
            onMouseEnter={(e) => e.target.style.background = '#E5A573'}
            onMouseLeave={(e) => e.target.style.background = '#D97757'}
          >
            Start exploring →
          </button>

          <button
            onClick={() => setAutoAdvanceActive(false)}
            style={{
              background: 'none',
              border: 'none',
              color: '#999',
              fontSize: 12,
              cursor: 'pointer',
              fontWeight: 500,
              transition: 'color 0.2s ease'
            }}
            onMouseEnter={(e) => e.target.style.color = '#ccc'}
            onMouseLeave={(e) => e.target.style.color = '#999'}
          >
            View my profile
          </button>
        </div>

        {/* Auto-advance countdown */}
        {autoAdvanceActive && (
          <div style={{
            marginTop: 24,
            fontSize: 11,
            color: '#666',
            animation: 'fadeIn 0.4s ease-out 1s both'
          }}>
            Continuing in {Math.max(0, countdown - 1)}...
          </div>
        )}
      </div>

      <style>{`
        @keyframes checkmarkPop {
          from {
            transform: scale(0);
            opacity: 0;
          }
          to {
            transform: scale(1);
            opacity: 1;
          }
        }

        @keyframes confetti0 {
          from {
            transform: translateY(0) translateX(0) rotate(0deg);
            opacity: 1;
          }
          to {
            transform: translateY(400px) translateX(-80px) rotate(720deg);
            opacity: 0;
          }
        }

        @keyframes confetti1 {
          from {
            transform: translateY(0) translateX(0) rotate(0deg);
            opacity: 1;
          }
          to {
            transform: translateY(420px) translateX(60px) rotate(-720deg);
            opacity: 0;
          }
        }

        @keyframes confetti2 {
          from {
            transform: translateY(0) translateX(0) rotate(0deg);
            opacity: 1;
          }
          to {
            transform: translateY(400px) translateX(-40px) rotate(360deg);
            opacity: 0;
          }
        }

        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(20px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        @keyframes fadeIn {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }
      `}</style>
    </div>
  );
}

Object.assign(window, { EmailVerifySuccessScreen });
