function SplashScreen() {
  const [state, setState] = React.useState('animating'); // 'animating' | 'complete'
  const [showReplay, setShowReplay] = React.useState(false);

  React.useEffect(() => {
    const timer = setTimeout(() => {
      setState('complete');
      setShowReplay(true);
    }, 1500);
    return () => clearTimeout(timer);
  }, []);

  const handleSkip = () => {
    setState('complete');
    setShowReplay(true);
  };

  const handleReplay = () => {
    setState('animating');
    setShowReplay(false);
  };

  return (
    <div
      onClick={handleSkip}
      style={{
        display: 'flex',
        flexDirection: 'column',
        height: '100%',
        width: '100%',
        background: 'linear-gradient(135deg, #1a1a1a 0%, #2d2a26 50%, #3a3530 100%)',
        position: 'relative',
        overflow: 'hidden',
        alignItems: 'center',
        justifyContent: 'center',
        opacity: state === 'complete' ? 0 : 1,
        transition: 'opacity 0.3s ease-out'
      }}
    >
      {/* Logo */}
      <div
        style={{
          fontSize: 64,
          marginBottom: 16,
          animation: state === 'animating' ? 'logoAppear 0.6s ease-out 0.2s both' : 'none'
        }}
      >
        {/* Geometric gaming icon */}
        <svg viewBox="0 0 100 100" width="80" height="80" style={{ display: 'block' }}>
          <defs>
            <linearGradient id="gameIconGrad" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" style={{ stopColor: '#D97757', stopOpacity: 1 }} />
              <stop offset="100%" style={{ stopColor: '#E5A573', stopOpacity: 1 }} />
            </linearGradient>
          </defs>
          {/* Controller/game icon */}
          <rect x="15" y="35" width="70" height="30" rx="8" fill="url(#gameIconGrad)" />
          <circle cx="28" cy="50" r="5" fill="#1a1a1a" />
          <circle cx="42" cy="50" r="5" fill="#1a1a1a" />
          <rect x="58" y="44" width="6" height="12" fill="#1a1a1a" />
          <rect x="68" y="44" width="6" height="12" fill="#1a1a1a" />
        </svg>
      </div>

      {/* Wordmark */}
      <div
        style={{
          fontSize: 36,
          fontWeight: 700,
          color: '#FFFFFF',
          marginBottom: 8,
          letterSpacing: '-0.025em',
          animation: state === 'animating' ? 'wordmarkAppear 0.6s ease-out 0.5s both' : 'none',
          textAlign: 'center'
        }}
      >
        Gaming Zone
      </div>

      {/* Tagline */}
      <div
        style={{
          fontSize: 13,
          color: '#999',
          marginBottom: 40,
          fontWeight: 400,
          animation: state === 'animating' ? 'taglineAppear 0.6s ease-out 0.8s both' : 'none'
        }}
      >
        Your game. Your rules.
      </div>

      {/* Loading indicator */}
      <div
        style={{
          animation: state === 'animating' ? 'loadingAppear 0.4s ease-out 1s both' : 'none'
        }}
      >
        <div style={{ display: 'flex', gap: 4, alignItems: 'center', justifyContent: 'center' }}>
          <div style={{ width: 4, height: 4, borderRadius: '50%', background: '#D97757', animation: 'pulse 1s ease-in-out infinite' }} />
          <div style={{ width: 4, height: 4, borderRadius: '50%', background: '#D97757', animation: 'pulse 1s ease-in-out 0.2s infinite' }} />
          <div style={{ width: 4, height: 4, borderRadius: '50%', background: '#D97757', animation: 'pulse 1s ease-in-out 0.4s infinite' }} />
        </div>
      </div>

      {/* Version */}
      <div
        style={{
          position: 'absolute',
          bottom: 16,
          fontSize: 9,
          color: '#555',
          letterSpacing: '0.05em'
        }}
      >
        v2.4.1
      </div>

      {/* Replay button */}
      {showReplay && (
        <button
          onClick={(e) => {
            e.stopPropagation();
            handleReplay();
          }}
          style={{
            position: 'absolute',
            top: 12,
            right: 12,
            fontSize: 12,
            background: 'rgba(255,255,255,0.1)',
            border: '1px solid rgba(255,255,255,0.2)',
            color: '#999',
            padding: '6px 10px',
            borderRadius: 4,
            cursor: 'pointer',
            transition: 'all 0.2s ease'
          }}
          onMouseEnter={(e) => {
            e.target.style.background = 'rgba(255,255,255,0.15)';
            e.target.style.color = '#ccc';
          }}
          onMouseLeave={(e) => {
            e.target.style.background = 'rgba(255,255,255,0.1)';
            e.target.style.color = '#999';
          }}
        >
          ↻ Replay
        </button>
      )}

      {/* Navigation preview after complete */}
      {state === 'complete' && (
        <div
          style={{
            position: 'absolute',
            bottom: 40,
            fontSize: 11,
            color: '#666',
            letterSpacing: '0.05em'
          }}
        >
          → Auth Landing
        </div>
      )}

      <style>{`
        @keyframes logoAppear {
          from {
            opacity: 0;
            transform: scale(0.7);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }

        @keyframes wordmarkAppear {
          from {
            opacity: 0;
            transform: translateY(20px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        @keyframes taglineAppear {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }

        @keyframes loadingAppear {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }

        @keyframes pulse {
          0%, 100% {
            opacity: 0.3;
          }
          50% {
            opacity: 1;
          }
        }
      `}</style>
    </div>
  );
}

Object.assign(window, { SplashScreen });
