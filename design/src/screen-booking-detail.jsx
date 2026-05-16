// Screen 32: Booking Detail
const { useState, useEffect } = React;

function BookingDetailScreen() {
  const [status, setStatus] = useState('confirmed'); // 'confirmed' | 'in-checkin' | 'pending-payment' | 'checked-in' | 'cancelled'
  const [showCancelDialog, setShowCancelDialog] = useState(false);
  const [countdownSeconds, setCountdownSeconds] = useState(66240); // 18 hrs 24 min

  useEffect(() => {
    const interval = setInterval(() => {
      setCountdownSeconds(prev => prev > 0 ? prev - 1 : prev);
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  const hours = Math.floor(countdownSeconds / 3600);
  const mins = Math.floor((countdownSeconds % 3600) / 60);
  const secs = countdownSeconds % 60;

  const statusColors = {
    confirmed: 'var(--gz-ok)',
    'in-checkin': 'var(--gz-ok)',
    'pending-payment': 'var(--gz-warn)',
    'checked-in': 'var(--gz-ok)',
    cancelled: 'var(--gz-err)',
  };

  const statusLabels = {
    confirmed: 'Confirmed',
    'in-checkin': 'Check-in window',
    'pending-payment': 'Pending payment',
    'checked-in': 'Checked in',
    cancelled: 'Cancelled',
  };

  return (
    <Phone width={390} height={800}>
      <TopBar title="Booking details" onBack={() => {}} />

      <Scroll>
        {/* Status banner */}
        <div style={{
          background: statusColors[status], color: 'var(--gz-fg)',
          padding: '12px 16px', borderRadius: 8, marginBottom: 16,
          fontSize: 13, fontWeight: 600, textAlign: 'center',
        }}>
          {statusLabels[status]}
        </div>

        {/* Booking reference */}
        <div style={{ marginBottom: 16 }}>
          <button onClick={() => {}}
            style={{
              background: 'var(--gz-pill)', border: 0, padding: '8px 12px',
              borderRadius: 8, fontFamily: 'monospace', fontSize: 12, fontWeight: 600,
              color: 'var(--gz-fg)', cursor: 'pointer',
            }}>
            BKG-20948
          </button>
        </div>

        {/* Store + system card */}
        <div className="gz-card" style={{ marginBottom: 16, padding: '16px' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 12 }}>
            <div>
              <div className="gz-h2">GameZone Koramangala</div>
              <div className="gz-body" style={{ color: 'var(--gz-fg-2)', marginTop: 4 }}>
                RTX 4090 Gaming PC · Seat 3
              </div>
            </div>
            <span className="gz-chip" style={{ background: 'var(--gz-pill)' }}>PC</span>
          </div>

          <MetaRow label="Date" value="Saturday, 19 April 2025" />
          <MetaRow label="Time" value="4:00 PM – 6:00 PM" />
          <MetaRow label="Duration" value="2 hours" />
        </div>

        {/* Pricing section */}
        <div className="gz-card" style={{ marginBottom: 16, padding: '16px' }}>
          <div className="gz-h2" style={{ marginBottom: 12 }}>Pricing</div>

          <MetaRow label="Base" value="₹80/hr × 2 hrs = ₹160" />
          <MetaRow label="Campaign" value="Happy Hour −₹48" valueClass="gz-text-ok" />
          <MetaRow label="Credits" value="−₹30 redeemed" valueClass="gz-text-ok" />

          <div style={{ borderTop: '1px solid var(--gz-rule)', paddingTop: 12, marginTop: 12 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span className="gz-h2" style={{ fontSize: 16 }}>Total</span>
              <span style={{ fontSize: 24, fontWeight: 700, color: 'var(--gz-fg)', fontFamily: 'var(--gz-font)' }}>₹82</span>
            </div>
          </div>

          <MetaRow label="Payment" value="UPI · Confirmed ✓" valueClass="gz-text-ok" />
        </div>

        {/* Check-in info */}
        <div className="gz-card" style={{ marginBottom: 16, padding: '16px', background: 'var(--gz-card-tint)' }}>
          <div style={{ display: 'flex', gap: 10, marginBottom: 8 }}>
            {React.cloneElement(I.info, { style: { width: 18, height: 18, color: 'var(--gz-fg-2)', flexShrink: 0 } })}
            <div className="gz-body-r" style={{ color: 'var(--gz-fg-2)', fontSize: 13 }}>
              Check-in opens at 3:45 PM · 15 min before session
            </div>
          </div>
        </div>

        {/* Countdown */}
        <div className="gz-card" style={{ marginBottom: 16, padding: '16px', textAlign: 'center' }}>
          <div className="gz-body-r" style={{ color: 'var(--gz-fg-3)', marginBottom: 8 }}>Session starts in</div>
          <div style={{ fontSize: 28, fontWeight: 700, color: 'var(--gz-fg)', fontFamily: 'monospace' }}>
            {String(hours).padStart(2, '0')}:{String(mins).padStart(2, '0')}:{String(secs).padStart(2, '0')}
          </div>
        </div>

        {/* Status selector toggle */}
        <div style={{ marginBottom: 16, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          <button onClick={() => setStatus('confirmed')} style={{
            padding: '6px 12px', fontSize: 11, fontWeight: 600, border: '1px solid var(--gz-rule)',
            borderRadius: 6, background: status === 'confirmed' ? 'var(--gz-ok)' : 'transparent',
            color: 'var(--gz-fg)', cursor: 'pointer',
          }}>confirmed</button>
          <button onClick={() => setStatus('in-checkin')} style={{
            padding: '6px 12px', fontSize: 11, fontWeight: 600, border: '1px solid var(--gz-rule)',
            borderRadius: 6, background: status === 'in-checkin' ? 'var(--gz-ok)' : 'transparent',
            color: 'var(--gz-fg)', cursor: 'pointer',
          }}>in-checkin</button>
          <button onClick={() => setStatus('pending-payment')} style={{
            padding: '6px 12px', fontSize: 11, fontWeight: 600, border: '1px solid var(--gz-rule)',
            borderRadius: 6, background: status === 'pending-payment' ? 'var(--gz-warn)' : 'transparent',
            color: 'var(--gz-fg)', cursor: 'pointer',
          }}>pending-payment</button>
          <button onClick={() => setStatus('checked-in')} style={{
            padding: '6px 12px', fontSize: 11, fontWeight: 600, border: '1px solid var(--gz-rule)',
            borderRadius: 6, background: status === 'checked-in' ? 'var(--gz-ok)' : 'transparent',
            color: 'var(--gz-fg)', cursor: 'pointer',
          }}>checked-in</button>
          <button onClick={() => setStatus('cancelled')} style={{
            padding: '6px 12px', fontSize: 11, fontWeight: 600, border: '1px solid var(--gz-rule)',
            borderRadius: 6, background: status === 'cancelled' ? 'var(--gz-err)' : 'transparent',
            color: 'var(--gz-fg)', cursor: 'pointer',
          }}>cancelled</button>
        </div>

        {/* Action buttons — status-driven */}
        {status === 'confirmed' && (
          <Button onClick={() => setShowCancelDialog(true)} variant="danger-outline">
            Cancel booking
          </Button>
        )}

        {status === 'in-checkin' && (
          <>
            <Button onClick={() => {}} style={{ marginBottom: 12, background: 'var(--gz-ok)' }}>
              Check In Now →
            </Button>
            <button onClick={() => setShowCancelDialog(true)}
              style={{
                width: '100%', padding: '14px 16px',
                fontSize: 15, fontWeight: 600, border: 0, borderRadius: 12,
                background: 'transparent', color: 'var(--gz-err)',
                cursor: 'pointer', textDecoration: 'underline',
              }}>
              Cancel
            </button>
          </>
        )}

        {status === 'pending-payment' && (
          <>
            <Button onClick={() => {}} style={{ marginBottom: 12, background: 'var(--gz-warn)', animation: 'pulse 2s ease-in-out infinite' }}>
              Pay ₹82 Now
            </Button>
            <Button onClick={() => setShowCancelDialog(true)} variant="danger-outline">
              Cancel booking
            </Button>
            <style>{`
              @keyframes pulse {
                0%, 100% { opacity: 1; }
                50% { opacity: 0.7; }
              }
            `}</style>
          </>
        )}

        {status === 'checked-in' && (
          <Button onClick={() => {}} style={{ background: 'var(--gz-ok)' }}>
            View active session →
          </Button>
        )}

        {status === 'cancelled' && (
          <>
            <Button onClick={() => {}} variant="danger-outline" style={{ marginBottom: 12 }}>
              File a dispute →
            </Button>
            <Button onClick={() => {}} variant="ghost">
              Book again →
            </Button>
          </>
        )}
      </Scroll>

      {/* Cancel confirmation dialog */}
      {showCancelDialog && (
        <div style={{
          position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
          background: 'rgba(0,0,0,0.5)', display: 'flex', alignItems: 'center', justifyContent: 'center',
          zIndex: 100,
        }}>
          <div style={{
            background: 'var(--gz-card)', borderRadius: 16, padding: '24px 20px',
            width: '80%', maxWidth: 320, boxShadow: '0 20px 60px rgba(0,0,0,0.2)',
          }}>
            <h2 className="gz-h2" style={{ marginBottom: 8, textAlign: 'center' }}>Cancel this booking?</h2>
            <p className="gz-body" style={{ color: 'var(--gz-fg-2)', marginBottom: 20, textAlign: 'center', fontSize: 13 }}>
              Cancellations within 2 hrs of session start may incur a fee.
            </p>

            <Button onClick={() => setShowCancelDialog(false)} variant="ghost" style={{ marginBottom: 12 }}>
              Keep booking
            </Button>
            <Button onClick={() => setShowCancelDialog(false)} style={{ background: 'var(--gz-err)' }}>
              Cancel booking
            </Button>
          </div>
        </div>
      )}
    </Phone>
  );
}

Object.assign(window, { BookingDetailScreen });
