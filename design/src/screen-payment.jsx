// Screen 18 — Payment Screen (Booking Payment)
// Player paying for a pending booking. Multiple payment methods, idempotency awareness, clear amount.

function PaymentScreen() {
  const [selectedMethod, setSelectedMethod] = useState('cash');
  const [upiId, setUpiId] = useState('');
  const [upiExpanded, setUpiExpanded] = useState(false);
  const [cardExpanded, setCardExpanded] = useState(false);
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);

  const amount = 82;
  const credits = 820;
  const dueToday = '11:00 PM';

  const handleConfirm = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setSuccess(true);
    }, 1500);
  };

  if (success) {
    return (
      <Phone>
        <TopBar title="Payment" onBack={() => setSuccess(false)} />
        <Scroll pad={false}>
          <div style={{
            padding: '60px 20px',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 20,
          }}>
            <div style={{
              width: 80, height: 80, borderRadius: 999,
              background: 'var(--gz-ok-bg)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              animation: 'pulse-scale 0.6s ease-out',
            }}>
              <svg width="40" height="40" viewBox="0 0 24 24" style={{ stroke: 'var(--gz-ok)', strokeWidth: 2.5, fill: 'none', strokeLinecap: 'round' }}>
                <path d="M5 12l5 5L20 7" />
              </svg>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div className="gz-title">Payment confirmed</div>
              <div className="gz-body-r" style={{ marginTop: 8 }}>Your booking is now active</div>
            </div>
            <button className="gz-btn" onClick={() => setSuccess(false)}>
              View booking →
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

  const isUsingCredits = selectedMethod === 'credits';
  const finalAmount = isUsingCredits ? 0 : amount;
  const ctaText = isUsingCredits ? `Confirm — ₹0 due` : `Confirm payment — ₹${amount}`;

  return (
    <Phone>
      <TopBar title="Complete payment" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '16px 16px' }}>
          {/* Amount hero */}
          <div style={{ textAlign: 'center', marginBottom: 28 }}>
            <div className="gz-hero" style={{ marginBottom: 6 }}>₹{amount}</div>
            <div className="gz-body-r">Due for booking BKG-20948</div>
          </div>

          {/* Booking mini-card */}
          <div className="gz-card" style={{
            marginBottom: 20,
            background: 'var(--gz-pill-bg)',
            padding: 14,
          }}>
            <div className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>
              RTX 4090 · Sat 19 Apr · 4PM–6PM · GameZone Koramangala
            </div>
          </div>

          {/* Payment deadline banner */}
          <div style={{
            background: 'var(--gz-warn-bg)',
            border: `1px solid var(--gz-warn)`,
            borderRadius: 16,
            padding: 14,
            marginBottom: 24,
            display: 'flex', alignItems: 'center', gap: 10,
          }}>
            <span style={{ color: 'var(--gz-warn)', flexShrink: 0, fontSize: 18 }}>⚠</span>
            <div className="gz-small" style={{ color: 'var(--gz-warn)', fontWeight: 600 }}>
              Pay before {dueToday} today or booking will be cancelled
            </div>
          </div>

          {/* Payment method section */}
          <div style={{ marginBottom: 24 }}>
            <div className="gz-h3" style={{ marginBottom: 12, color: 'var(--gz-fg)' }}>Payment method</div>

            {/* Cash */}
            <button
              onClick={() => setSelectedMethod('cash')}
              style={{
                width: '100%', padding: '16px', marginBottom: 10,
                background: selectedMethod === 'cash' ? 'var(--gz-card-tint)' : 'var(--gz-card)',
                border: selectedMethod === 'cash' ? `2px solid var(--gz-card-tint-strong)` : `1px solid var(--gz-rule)`,
                borderRadius: 16, cursor: 'pointer',
                display: 'flex', alignItems: 'center', gap: 14,
                transition: 'all 0.15s',
              }}>
              <span style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 24, height: 24, color: 'var(--gz-fg)', flexShrink: 0 }}>
                {React.cloneElement(I.cash, { style: { width: 20, height: 20 } })}
              </span>
              <div style={{ flex: 1, textAlign: 'left' }}>
                <div className="gz-body" style={{ fontWeight: 600 }}>Cash</div>
                <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>Pay at store counter</div>
              </div>
              <span style={{ color: 'var(--gz-fg-3)', flexShrink: 0 }}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <circle cx="12" cy="12" r="10" opacity="0.2"/>
                  <circle cx="12" cy="12" r="4" fill={selectedMethod === 'cash' ? 'var(--gz-fg)' : 'transparent'}/>
                </svg>
              </span>
            </button>

            {/* UPI */}
            <button
              onClick={() => { setSelectedMethod('upi'); setUpiExpanded(!upiExpanded); }}
              style={{
                width: '100%', padding: '16px', marginBottom: 10,
                background: selectedMethod === 'upi' ? 'var(--gz-card-tint)' : 'var(--gz-card)',
                border: selectedMethod === 'upi' ? `2px solid var(--gz-card-tint-strong)` : `1px solid var(--gz-rule)`,
                borderRadius: 16, cursor: 'pointer',
                display: 'flex', alignItems: 'center', gap: 14,
                transition: 'all 0.15s',
              }}>
              <span style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 24, height: 24, color: 'var(--gz-fg)', flexShrink: 0 }}>
                {React.cloneElement(I.upi, { style: { width: 20, height: 20 } })}
              </span>
              <div style={{ flex: 1, textAlign: 'left' }}>
                <div className="gz-body" style={{ fontWeight: 600 }}>UPI</div>
                <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>Enter UPI ID or scan QR</div>
              </div>
              <span style={{ color: 'var(--gz-fg-3)', flexShrink: 0 }}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <circle cx="12" cy="12" r="10" opacity="0.2"/>
                  <circle cx="12" cy="12" r="4" fill={selectedMethod === 'upi' ? 'var(--gz-fg)' : 'transparent'}/>
                </svg>
              </span>
            </button>
            {selectedMethod === 'upi' && upiExpanded && (
              <div style={{ padding: '12px 16px', background: 'var(--gz-card)', borderRadius: '0 0 16px 16px', marginBottom: 10, marginTop: -10 }}>
                <input
                  type="text"
                  placeholder="yourname@upi"
                  value={upiId}
                  onChange={(e) => setUpiId(e.target.value)}
                  style={{
                    width: '100%', padding: '12px 12px',
                    background: 'var(--gz-pill-bg)', border: 0, borderRadius: 10,
                    fontSize: 14, fontFamily: 'var(--gz-font)',
                    marginBottom: 10,
                  }}
                />
                <button style={{
                  width: '100%', padding: '10px',
                  background: 'var(--gz-btn)', color: 'var(--gz-btn-fg)',
                  border: 0, borderRadius: 10,
                  fontSize: 13, fontWeight: 600, cursor: 'pointer',
                }}>Verify</button>
              </div>
            )}

            {/* Card */}
            <button
              onClick={() => { setSelectedMethod('card'); setCardExpanded(!cardExpanded); }}
              style={{
                width: '100%', padding: '16px', marginBottom: 10,
                background: selectedMethod === 'card' ? 'var(--gz-card-tint)' : 'var(--gz-card)',
                border: selectedMethod === 'card' ? `2px solid var(--gz-card-tint-strong)` : `1px solid var(--gz-rule)`,
                borderRadius: 16, cursor: 'pointer',
                display: 'flex', alignItems: 'center', gap: 14,
                transition: 'all 0.15s',
              }}>
              <span style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 24, height: 24, color: 'var(--gz-fg)', flexShrink: 0 }}>
                {React.cloneElement(I.card, { style: { width: 20, height: 20 } })}
              </span>
              <div style={{ flex: 1, textAlign: 'left' }}>
                <div className="gz-body" style={{ fontWeight: 600 }}>Card</div>
                <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>Debit or credit card</div>
              </div>
              <span style={{ color: 'var(--gz-fg-3)', flexShrink: 0 }}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <circle cx="12" cy="12" r="10" opacity="0.2"/>
                  <circle cx="12" cy="12" r="4" fill={selectedMethod === 'card' ? 'var(--gz-fg)' : 'transparent'}/>
                </svg>
              </span>
            </button>
            {selectedMethod === 'card' && cardExpanded && (
              <div style={{ padding: '12px 16px', background: 'var(--gz-card)', borderRadius: '0 0 16px 16px', marginBottom: 10, marginTop: -10 }}>
                <input placeholder="Card number" style={{
                  width: '100%', padding: '12px 12px', marginBottom: 8,
                  background: 'var(--gz-pill-bg)', border: 0, borderRadius: 10,
                  fontSize: 14, fontFamily: 'var(--gz-font)',
                }}/>
                <div style={{ display: 'flex', gap: 8 }}>
                  <input placeholder="MM/YY" style={{
                    flex: 1, padding: '12px 12px',
                    background: 'var(--gz-pill-bg)', border: 0, borderRadius: 10,
                    fontSize: 14, fontFamily: 'var(--gz-font)',
                  }}/>
                  <input placeholder="CVV" style={{
                    flex: 0.5, padding: '12px 12px',
                    background: 'var(--gz-pill-bg)', border: 0, borderRadius: 10,
                    fontSize: 14, fontFamily: 'var(--gz-font)',
                  }}/>
                </div>
              </div>
            )}

            {/* Credits */}
            <button
              onClick={() => setSelectedMethod('credits')}
              style={{
                width: '100%', padding: '16px', marginBottom: 10,
                background: selectedMethod === 'credits' ? 'var(--gz-card-tint)' : 'var(--gz-card)',
                border: selectedMethod === 'credits' ? `2px solid var(--gz-card-tint-strong)` : `1px solid var(--gz-rule)`,
                borderRadius: 16, cursor: 'pointer',
                display: 'flex', alignItems: 'center', gap: 14,
                transition: 'all 0.15s',
              }}>
              <span style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 24, height: 24, color: 'var(--gz-fg)', flexShrink: 0 }}>
                {React.cloneElement(I.coin, { style: { width: 20, height: 20 } })}
              </span>
              <div style={{ flex: 1, textAlign: 'left' }}>
                <div className="gz-body" style={{ fontWeight: 600 }}>Credits</div>
                <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>
                  Use {credits} credits = ₹{amount} off · Full amount covered
                </div>
              </div>
              <span style={{ color: 'var(--gz-fg-3)', flexShrink: 0 }}>
                {isUsingCredits && (
                  <span className="gz-tag gz-tag--ok" style={{ marginRight: 8 }}>Exact</span>
                )}
                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                  <circle cx="12" cy="12" r="10" opacity="0.2"/>
                  <circle cx="12" cy="12" r="4" fill={selectedMethod === 'credits' ? 'var(--gz-fg)' : 'transparent'}/>
                </svg>
              </span>
            </button>
          </div>

          {/* Security note */}
          <div style={{
            display: 'flex', alignItems: 'center', gap: 8,
            marginBottom: 24, padding: '12px', background: 'var(--gz-info-bg)',
            borderRadius: 12,
          }}>
            <span style={{ color: 'var(--gz-info)' }}>🔒</span>
            <div className="gz-small" style={{ color: 'var(--gz-info)' }}>Payments secured by Stripe</div>
          </div>
        </div>
      </Scroll>

      {/* Sticky CTA */}
      <div style={{
        padding: '12px 16px 20px', flexShrink: 0,
        background: 'var(--gz-bg)', borderTop: `1px solid var(--gz-rule)`,
      }}>
        <button
          onClick={handleConfirm}
          disabled={loading}
          style={{
            width: '100%',
            padding: '16px 20px',
            background: loading ? 'var(--gz-fg-3)' : 'var(--gz-btn)',
            color: 'var(--gz-btn-fg)',
            border: 0, borderRadius: 16,
            fontSize: 15, fontWeight: 600,
            cursor: loading ? 'default' : 'pointer',
            opacity: loading ? 0.6 : 1,
            marginBottom: 8,
          }}>
          {loading ? 'Processing...' : ctaText}
        </button>
        <button style={{
          width: '100%',
          padding: '12px', background: 'transparent', border: 0,
          color: 'var(--gz-err)', fontSize: 14, fontWeight: 600,
          cursor: 'pointer',
        }}>Cancel booking</button>
      </div>
    </Phone>
  );
}

Object.assign(window, { PaymentScreen });
