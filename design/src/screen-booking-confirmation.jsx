// Screen 22: Booking Confirmation
// Post-booking success screen with live countdown and interactive elements

const { useState, useEffect } = React;

function BookingConfirmationScreen() {
  const [copied, setCopied] = useState(false);
  const [timeLeft, setTimeLeft] = useState({ hours: 18, minutes: 24 });
  const [paymentState, setPaymentState] = useState('paid'); // 'paid' or 'pending'
  const [showShare, setShowShare] = useState(false);
  const [calendarAdded, setCalendarAdded] = useState(false);

  // Live countdown
  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft(prev => {
        let { hours, minutes } = prev;
        if (minutes === 0) {
          if (hours === 0) return { hours: 0, minutes: 0 };
          hours--;
          minutes = 59;
        } else {
          minutes--;
        }
        return { hours, minutes };
      });
    }, 60000); // update every minute
    return () => clearInterval(timer);
  }, []);

  const handleCopyRef = () => {
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <Phone>
      {/* X close button top right */}
      <div style={{
        padding: '8px 16px 12px',
        display: 'flex',
        justifyContent: 'flex-end',
        flexShrink: 0,
      }}>
        <button style={{
          width: 38,
          height: 38,
          border: 0,
          background: 'transparent',
          color: 'var(--gz-fg)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          padding: 0,
          cursor: 'pointer',
        }}>
          {I.x}
        </button>
      </div>

      <Scroll>
        {/* Success checkmark animation */}
        <div style={{
          height: 100,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          marginBottom: 20,
        }}>
          <svg
            width="80"
            height="80"
            viewBox="0 0 80 80"
            style={{
              color: 'var(--gz-ok)',
              animation: 'scaleIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)',
            }}
          >
            <circle cx="40" cy="40" r="38" fill="none" stroke="currentColor" strokeWidth="2"/>
            <path
              d="M25 40l8 8 22-22"
              fill="none"
              stroke="currentColor"
              strokeWidth="3"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </div>

        <style>{`
          @keyframes scaleIn {
            0% { transform: scale(0.6); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
          }
        `}</style>

        <h1 className="gz-h1" style={{
          textAlign: 'center',
          marginBottom: 20,
          fontSize: 24,
          fontWeight: 700,
        }}>
          Booking confirmed!
        </h1>

        {/* Booking reference */}
        <button
          onClick={handleCopyRef}
          style={{
            width: '100%',
            background: 'var(--gz-pill-bg)',
            border: 0,
            padding: '12px 16px',
            borderRadius: 'var(--gz-r-chip)',
            marginBottom: 20,
            cursor: 'pointer',
            fontFamily: 'var(--gz-mono)',
            fontSize: 13,
            fontWeight: 700,
            color: 'var(--gz-fg)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
          }}
        >
          BKG-20948
          {copied && <span style={{ fontSize: 12 }}>✓ Copied</span>}
        </button>

        {/* Booking summary card */}
        <div className="gz-card" style={{ marginBottom: 20 }}>
          <div style={{ marginBottom: 12 }}>
            <div className="gz-body" style={{ color: 'var(--gz-fg-2)', fontSize: 12, marginBottom: 4 }}>BOOKING DETAILS</div>
          </div>
          <MetaRow label="Store" value="GameZone Koramangala" valueClass="" />
          <MetaRow label="System" value="RTX 4090 PC" valueClass="" />
          <MetaRow label="Seat" value="#3" valueClass="" />
          <MetaRow label="Date & time" value="18 Apr, 4:00 PM" valueClass="" />
          <MetaRow label="Duration" value="2 hours" valueClass="" />
        </div>

        {/* Payment status */}
        {paymentState === 'paid' ? (
          <div style={{
            background: 'var(--gz-ok-bg)',
            border: `1px solid rgba(${46}, ${122}, ${60}, 0.2)`,
            borderRadius: 'var(--gz-r-inner)',
            padding: '14px 16px',
            marginBottom: 20,
            display: 'flex',
            alignItems: 'center',
            gap: 10,
          }}>
            <span style={{ color: 'var(--gz-ok)', fontSize: 16 }}>✓</span>
            <div>
              <div className="gz-body" style={{ color: 'var(--gz-ok)', fontWeight: 600 }}>
                ₹82 paid via UPI
              </div>
            </div>
          </div>
        ) : (
          <div style={{
            background: 'var(--gz-warn-bg)',
            border: `1px solid rgba(${138}, ${90}, ${18}, 0.2)`,
            borderRadius: 'var(--gz-r-inner)',
            padding: '14px 16px',
            marginBottom: 20,
          }}>
            <div className="gz-body" style={{ color: 'var(--gz-warn)', fontWeight: 600, marginBottom: 4 }}>
              Pay ₹82 at store before 11:00 PM tonight
            </div>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>
              Countdown: 5 hrs 23 min
            </div>
          </div>
        )}

        {/* Check-in info */}
        <div style={{
          background: 'var(--gz-info-bg)',
          border: `1px solid rgba(${42}, ${74}, ${138}, 0.15)`,
          borderRadius: 'var(--gz-r-inner)',
          padding: '14px 16px',
          marginBottom: 20,
        }}>
          <div className="gz-body" style={{ color: 'var(--gz-info)', fontWeight: 600, marginBottom: 4 }}>
            Check-in opens 15 min before your session
          </div>
          <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>
            Seat 3 will be reserved for you
          </div>
        </div>

        {/* Session countdown */}
        <div style={{
          background: 'var(--gz-card)',
          border: `1px solid var(--gz-rule)`,
          borderRadius: 'var(--gz-r-inner)',
          padding: '14px 16px',
          marginBottom: 20,
          textAlign: 'center',
        }}>
          <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 4 }}>Session starts in</div>
          <div className="gz-hero-md" style={{ color: 'var(--gz-fg)' }}>
            {timeLeft.hours}h {timeLeft.minutes}m
          </div>
        </div>

        {/* Action buttons */}
        <div style={{
          display: 'flex',
          gap: 10,
          marginBottom: 20,
        }}>
          <button
            onClick={() => setCalendarAdded(!calendarAdded)}
            style={{
              flex: 1,
              height: 44,
              padding: '0 16px',
              background: calendarAdded ? 'var(--gz-ok-bg)' : 'var(--gz-pill-bg)',
              border: `1px solid var(--gz-rule)`,
              borderRadius: 'var(--gz-r-inner)',
              color: calendarAdded ? 'var(--gz-ok)' : 'var(--gz-fg)',
              fontSize: 13,
              fontWeight: 600,
              cursor: 'pointer',
              fontFamily: 'inherit',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: 6,
            }}
          >
            {I.cal}
            {calendarAdded ? 'Added' : 'Add to calendar'}
          </button>
          <button
            onClick={() => setShowShare(true)}
            style={{
              flex: 1,
              height: 44,
              padding: '0 16px',
              background: 'var(--gz-pill-bg)',
              border: `1px solid var(--gz-rule)`,
              borderRadius: 'var(--gz-r-inner)',
              color: 'var(--gz-fg)',
              fontSize: 13,
              fontWeight: 600,
              cursor: 'pointer',
              fontFamily: 'inherit',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: 6,
            }}
          >
            {I.share}
            Share
          </button>
        </div>

        {/* Primary CTA */}
        <button className="gz-btn" style={{ marginBottom: 12 }}>
          View booking details →
        </button>

        {/* Back to home link */}
        <button
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
          Back to home
        </button>
      </Scroll>

      {showShare && (
        <div className="gz-sheet-overlay" onClick={() => setShowShare(false)}>
          <div className="gz-sheet" onClick={(e) => e.stopPropagation()}>
            <div className="gz-sheet__grab" />
            <div className="gz-h2" style={{ marginBottom: 16 }}>Share booking</div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              <button style={{
                background: 'var(--gz-pill-bg)',
                border: 0,
                padding: '14px 16px',
                borderRadius: 'var(--gz-r-inner)',
                textAlign: 'left',
                cursor: 'pointer',
                fontFamily: 'inherit',
                color: 'var(--gz-fg)',
                fontWeight: 600,
              }}>
                WhatsApp
              </button>
              <button style={{
                background: 'var(--gz-pill-bg)',
                border: 0,
                padding: '14px 16px',
                borderRadius: 'var(--gz-r-inner)',
                textAlign: 'left',
                cursor: 'pointer',
                fontFamily: 'inherit',
                color: 'var(--gz-fg)',
                fontWeight: 600,
              }}>
                Copy link
              </button>
            </div>
          </div>
        </div>
      )}
    </Phone>
  );
}

window.BookingConfirmationScreen = BookingConfirmationScreen;
