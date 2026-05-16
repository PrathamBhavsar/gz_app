function NotificationDetailSheet() {
  const [showSheet, setShowSheet] = React.useState(true);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: '#000' }}>
      {/* Home Feed context (blurred) */}
      <div
        style={{
          flex: 1,
          background: 'linear-gradient(135deg, #f5f5f0 0%, #e8e5df 100%)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          filter: 'blur(2px)',
          position: 'relative'
        }}
      >
        <div style={{ fontSize: 24, color: '#ccc', textAlign: 'center' }}>
          Home Feed<br /><span style={{ fontSize: 12, color: '#aaa' }}>(context behind sheet)</span>
        </div>
      </div>

      {/* Bottom sheet */}
      {showSheet && (
        <div
          style={{
            background: 'var(--gz-bg)',
            borderTopLeftRadius: 24,
            borderTopRightRadius: 24,
            display: 'flex',
            flexDirection: 'column',
            maxHeight: '60%',
            padding: '16px 16px',
            boxSizing: 'border-box',
            animation: 'slideUpSheet 0.3s ease-out'
          }}
        >
          {/* Handle bar */}
          <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 12 }}>
            <div style={{ width: 40, height: 4, background: 'var(--gz-rule)', borderRadius: 2 }} />
          </div>

          {/* Header with icon and close */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
            {/* Notification icon circle */}
            <Avatar size="xl" bg="#E5DCEE" iconColor="var(--gz-fg)" icon={I.bell} />
            <button
              onClick={() => setShowSheet(false)}
              style={{
                marginLeft: 'auto',
                background: 'none',
                border: 'none',
                cursor: 'pointer',
                color: 'var(--gz-fg)',
                width: 38,
                height: 38,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              {React.cloneElement(I.x, { style: { width: 20, height: 20 } })}
            </button>
          </div>

          {/* Notification type label */}
          <div style={{ fontSize: 10, color: 'var(--gz-fg-3)', fontWeight: 600, marginBottom: 8, textTransform: 'uppercase', letterSpacing: '0.12em' }}>
            Booking Reminder
          </div>

          {/* Title */}
          <div style={{ fontSize: 16, fontWeight: 700, color: 'var(--gz-fg)', marginBottom: 12 }}>
            Your session starts in 30 minutes
          </div>

          {/* Body text */}
          <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', lineHeight: 1.5, marginBottom: 12 }}>
            You have a booking at GameZone Koramangala for the RTX 4090 Gaming PC (Seat 3). Your session starts at 4:00 PM. Check in opens at 3:45 PM — don't be late!
          </div>

          {/* Timestamp */}
          <div style={{ fontSize: 11, color: 'var(--gz-fg-3)', marginBottom: 16 }}>
            Today at 3:30 PM
          </div>

          {/* Action button */}
          <button
            style={{
              width: '100%',
              padding: '12px',
              background: 'var(--gz-fg)',
              color: 'var(--gz-bg)',
              border: 'none',
              borderRadius: 8,
              fontWeight: 600,
              fontSize: 14,
              cursor: 'pointer',
              marginBottom: 8
            }}
          >
            View booking →
          </button>

          {/* Dismiss link */}
          <button
            onClick={() => setShowSheet(false)}
            style={{
              width: '100%',
              padding: '8px',
              background: 'none',
              color: 'var(--gz-fg-2)',
              border: 'none',
              fontWeight: 500,
              fontSize: 13,
              cursor: 'pointer'
            }}
          >
            Dismiss
          </button>
        </div>
      )}

      <style>{`
        @keyframes slideUpSheet {
          from {
            transform: translateY(100%);
          }
          to {
            transform: translateY(0);
          }
        }
      `}</style>
    </div>
  );
}

function OTPInputSheet() {
  const [otp, setOtp] = React.useState('429');
  const [error, setError] = React.useState(false);
  const [success, setSuccess] = React.useState(false);
  const [countdownSeconds, setCountdownSeconds] = React.useState(31);

  React.useEffect(() => {
    const timer = setInterval(() => {
      setCountdownSeconds(prev => prev > 0 ? prev - 1 : 0);
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const handleNumberClick = (num) => {
    if (otp.length < 6) {
      const newOtp = otp + num;
      setOtp(newOtp);
      setError(false);
      if (newOtp.length === 6) {
        // Auto-submit on 6 digits
        setTimeout(() => {
          if (newOtp === '429123') {
            setSuccess(true);
            setTimeout(() => {
              // Auto-dismiss after success
            }, 1500);
          } else {
            setError(true);
            setOtp('');
          }
        }, 400);
      }
    }
  };

  const handleBackspace = () => {
    setOtp(otp.slice(0, -1));
  };

  const handleVerifyClick = () => {
    if (otp.length === 6) {
      if (otp === '429123') {
        setSuccess(true);
      } else {
        setError(true);
        setOtp('');
      }
    }
  };

  if (success) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--gz-bg)', padding: '20px', boxSizing: 'border-box' }}>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 16 }}>
          <div style={{ fontSize: 56, color: 'var(--gz-ok)' }}>✓</div>
          <div style={{ fontSize: 16, fontWeight: 600, color: 'var(--gz-fg)' }}>Phone number updated ✓</div>
        </div>
      </div>
    );
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--gz-bg)', position: 'relative' }}>
      {/* Sheet content */}
      <div style={{ display: 'flex', flexDirection: 'column', flex: 1, padding: '16px', boxSizing: 'border-box' }}>
        {/* Handle bar */}
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 16 }}>
          <div style={{ width: 40, height: 4, background: 'var(--gz-rule)', borderRadius: 2 }} />
        </div>

        {/* Context label */}
        <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 8 }}>
          Verifying new phone number
        </div>

        {/* Masked number */}
        <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', marginBottom: 24 }}>
          +91 ••••• 43210
        </div>

        {/* OTP Input boxes */}
        <div style={{ display: 'flex', gap: 8, marginBottom: 20, justifyContent: 'center' }}>
          {[0, 1, 2, 3, 4, 5].map(i => (
            <div
              key={i}
              style={{
                width: 44,
                height: 44,
                borderRadius: 8,
                background: error ? 'var(--gz-err)' : 'var(--gz-card)',
                border: error ? '2px solid #C85E54' : '1px solid var(--gz-rule)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 18,
                fontWeight: 700,
                color: 'var(--gz-fg)',
                animation: error ? 'shake 0.3s ease-out' : 'none',
                transition: 'all 0.2s ease'
              }}
            >
              {otp[i] || ''}
            </div>
          ))}
        </div>

        {/* Error message */}
        {error && (
          <div style={{ fontSize: 11, color: '#C85E54', fontWeight: 600, marginBottom: 20, textAlign: 'center' }}>
            ✗ Incorrect code
          </div>
        )}

        {/* Resend countdown */}
        <div style={{ fontSize: 11, color: 'var(--gz-fg-2)', marginBottom: 20, textAlign: 'center' }}>
          Resend in 0:{countdownSeconds < 10 ? '0' : ''}{countdownSeconds}
        </div>

        {/* Confirm button */}
        <button
          onClick={handleVerifyClick}
          disabled={otp.length < 6}
          style={{
            width: '100%',
            padding: '12px',
            background: otp.length === 6 ? 'var(--gz-fg)' : '#D5D5D0',
            color: otp.length === 6 ? 'var(--gz-bg)' : 'var(--gz-fg-2)',
            border: 'none',
            borderRadius: 8,
            fontWeight: 600,
            fontSize: 14,
            cursor: otp.length === 6 ? 'pointer' : 'default',
            marginBottom: 12
          }}
        >
          Confirm
        </button>

        {/* Wrong number link */}
        <button
          style={{
            background: 'none',
            border: 'none',
            color: 'var(--gz-fg-2)',
            fontSize: 12,
            cursor: 'pointer',
            fontWeight: 500
          }}
        >
          Wrong number? Cancel
        </button>
      </div>

      {/* Number pad */}
      <div style={{ background: 'var(--gz-card)', borderTop: '1px solid var(--gz-rule)', padding: '12px', boxSizing: 'border-box' }}>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
          {[1, 2, 3, 4, 5, 6, 7, 8, 9].map(num => (
            <button
              key={num}
              onClick={() => handleNumberClick(num)}
              style={{
                padding: '12px',
                background: 'var(--gz-pill-bg)',
                border: '1px solid var(--gz-rule)',
                borderRadius: 8,
                fontSize: 16,
                fontWeight: 600,
                color: 'var(--gz-fg)',
                cursor: 'pointer',
                transition: 'all 0.1s ease'
              }}
              onMouseDown={(e) => e.target.style.background = 'var(--gz-rule)'}
              onMouseUp={(e) => e.target.style.background = 'var(--gz-pill-bg)'}
            >
              {num}
            </button>
          ))}
        </div>

        {/* 0 and backspace */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8, marginTop: 8 }}>
          <button
            onClick={() => handleNumberClick(0)}
            style={{
              padding: '12px',
              background: 'var(--gz-pill-bg)',
              border: '1px solid var(--gz-rule)',
              borderRadius: 8,
              fontSize: 16,
              fontWeight: 600,
              color: 'var(--gz-fg)',
              cursor: 'pointer'
            }}
          >
            0
          </button>
          <button
            onClick={handleBackspace}
            style={{
              padding: '12px',
              background: 'var(--gz-pill-bg)',
              border: '1px solid var(--gz-rule)',
              borderRadius: 8,
              fontSize: 16,
              fontWeight: 600,
              color: 'var(--gz-fg)',
              cursor: 'pointer'
            }}
          >
            ⌫
          </button>
        </div>
      </div>

      <style>{`
        @keyframes shake {
          0%, 100% { transform: translateX(0); }
          25% { transform: translateX(-4px); }
          75% { transform: translateX(4px); }
        }
      `}</style>
    </div>
  );
}

Object.assign(window, { NotificationDetailSheet, OTPInputSheet });
