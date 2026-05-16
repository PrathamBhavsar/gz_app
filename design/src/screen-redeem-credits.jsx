// Screen 26 — Redeem Credits
// Player converting credits to a discount. Modal bottom sheet style. High-stakes confirmation flow.

function RedeemCreditsScreen() {
  const [step, setStep] = useState('input'); // 'input' | 'confirm' | 'success'
  const [redeemAmt, setRedeemAmt] = useState(300);
  const totalCredits = 850;
  const store = 'GameZone Koramangala';
  const conversionRate = 10; // 10 credits = ₹1

  const remaining = totalCredits - redeemAmt;
  const rupeeValue = (redeemAmt / conversionRate).toFixed(2);

  const handleRedeem = () => {
    setStep('confirm');
  };

  const handleConfirm = () => {
    setStep('success');
  };

  return (
    <Phone>
      {step === 'input' && (
        <div className="gz-sheet-overlay">
          <div className="gz-sheet" style={{ maxHeight: '90vh', overflowY: 'auto' }}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 4 }}>Redeem credits</div>
            <div className="gz-body-r" style={{ marginBottom: 20 }}>
              At {store}
            </div>

            {/* balance display */}
            <div className="gz-card gz-card--inset" style={{ marginBottom: 20, textAlign: 'center' }}>
              <div className="gz-meta" style={{ marginBottom: 8, color: 'var(--gz-fg-2)' }}>AVAILABLE BALANCE</div>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'center', gap: 8, marginBottom: 4 }}>
                <span className="gz-hero-md">{totalCredits}</span>
                <span className="gz-body" style={{ color: 'var(--gz-fg-2)' }}>credits</span>
              </div>
              <div className="gz-body" style={{ color: 'var(--gz-fg-2)', fontSize: 13 }}>
                = <span className="gz-num">₹{(totalCredits / conversionRate).toFixed(2)}</span> in-store value
              </div>
            </div>

            {/* amount input */}
            <div style={{ marginBottom: 20 }}>
              <div className="gz-meta" style={{ marginBottom: 12, color: 'var(--gz-fg-2)' }}>HOW MANY CREDITS?</div>
              <div className="gz-card gz-card--inset" style={{ textAlign: 'center', marginBottom: 14 }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 16 }}>
                  <button onClick={() => setRedeemAmt(Math.max(0, redeemAmt - 50))}
                    style={{
                      width: 36, height: 36,
                      background: 'var(--gz-btn)',
                      color: '#fff',
                      border: 0, borderRadius: 999,
                      fontSize: 18, fontWeight: 600,
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                      cursor: 'pointer',
                    }}>
                    −
                  </button>
                  <input type="number" value={redeemAmt}
                    onChange={e => setRedeemAmt(Math.min(totalCredits, Math.max(0, +e.target.value)))}
                    style={{
                      width: 100,
                      fontSize: 36, fontWeight: 700, textAlign: 'center',
                      border: 0, background: 'transparent',
                      fontFamily: 'var(--gz-mono)',
                      color: 'var(--gz-fg)',
                    }} />
                  <button onClick={() => setRedeemAmt(Math.min(totalCredits, redeemAmt + 50))}
                    style={{
                      width: 36, height: 36,
                      background: 'var(--gz-btn)',
                      color: '#fff',
                      border: 0, borderRadius: 999,
                      fontSize: 18, fontWeight: 600,
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                      cursor: 'pointer',
                    }}>
                    +
                  </button>
                </div>

                <div style={{ marginTop: 14 }}>
                  <button onClick={() => setRedeemAmt(totalCredits)}
                    style={{
                      padding: '6px 12px',
                      background: 'var(--gz-pill-bg)',
                      border: 0, borderRadius: 999,
                      fontSize: 12, fontWeight: 600,
                      color: 'var(--gz-fg)',
                      cursor: 'pointer',
                    }}>
                    Max
                  </button>
                </div>
              </div>

              <div className="gz-card gz-card--tint" style={{ padding: 14, marginBottom: 16 }}>
                <div className="gz-h2" style={{ textAlign: 'center', marginBottom: 4 }}>
                  <span className="gz-num">{redeemAmt}</span> credits
                </div>
                <div style={{ textAlign: 'center', color: 'var(--gz-fg-2)' }}>
                  = <span className="gz-num">₹{rupeeValue}</span> off your next booking
                </div>
              </div>

              <div className="gz-small" style={{ color: 'var(--gz-fg-2)', marginBottom: 6 }}>
                <strong>Remaining after:</strong> <span className="gz-num">{remaining}</span> credits
              </div>
            </div>

            {/* terms */}
            <div style={{ marginBottom: 20 }}>
              <div className="gz-meta" style={{ marginBottom: 10, color: 'var(--gz-fg-2)' }}>TERMS</div>
              <div className="gz-small" style={{ color: 'var(--gz-fg-2)', lineHeight: 1.6 }}>
                <div style={{ marginBottom: 8 }}>
                  • Credits valid at <strong>{store}</strong> only
                </div>
                <div style={{ marginBottom: 8 }}>
                  • Expires 90 days after earning
                </div>
                <div>
                  • Redeemable at checkout during booking · Cannot be converted to cash
                </div>
              </div>
            </div>

            <button className="gz-btn" onClick={handleRedeem}>
              Redeem {redeemAmt} credits
            </button>
          </div>
        </div>
      )}

      {step === 'confirm' && (
        <div className="gz-sheet-overlay">
          <div className="gz-sheet">
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 20, textAlign: 'center' }}>Confirm redemption</div>

            <div className="gz-card gz-card--inset" style={{ marginBottom: 20, padding: 18 }}>
              <div className="gz-body-r" style={{ marginBottom: 12, textAlign: 'center' }}>
                You are redeeming
              </div>
              <div style={{ textAlign: 'center', marginBottom: 4 }}>
                <span className="gz-hero-md">{redeemAmt}</span>
                <span className="gz-body" style={{ color: 'var(--gz-fg-2)', marginLeft: 6 }}>credits</span>
              </div>
              <div style={{ textAlign: 'center', color: 'var(--gz-fg-2)' }}>
                <span className="gz-num">₹{rupeeValue}</span> discount from <strong>{store}</strong>
              </div>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 0 }}>
              <button className="gz-btn" onClick={handleConfirm}>
                Confirm
              </button>
              <button className="gz-btn gz-btn--ghost" onClick={() => setStep('input')}>
                Go back
              </button>
            </div>
          </div>
        </div>
      )}

      {step === 'success' && (
        <div className="gz-sheet-overlay">
          <div className="gz-sheet" style={{ textAlign: 'center' }}>
            <div className="gz-sheet__grab" />
            <div style={{ fontSize: 56, marginTop: 20, marginBottom: 16 }}>✓</div>
            <div className="gz-h1" style={{ marginBottom: 8 }}>
              {redeemAmt} credits redeemed!
            </div>
            <div className="gz-body" style={{ color: 'var(--gz-fg-2)', marginBottom: 20 }}>
              Your discount is ready to use at checkout
            </div>

            <div className="gz-card gz-card--tint" style={{ marginBottom: 20 }}>
              <div className="gz-small" style={{ color: 'var(--gz-fg-2)', marginBottom: 6 }}>
                Balance after redemption
              </div>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'center', gap: 8 }}>
                <span className="gz-hero-md">{remaining}</span>
                <span className="gz-body" style={{ color: 'var(--gz-fg-2)' }}>credits left</span>
              </div>
            </div>

            <div className="gz-body-r" style={{ marginBottom: 20, color: 'var(--gz-fg-2)' }}>
              Use your ₹{rupeeValue} discount at your next booking
            </div>

            <button className="gz-btn" onClick={() => setStep('input')}>
              Close
            </button>
          </div>
        </div>
      )}
    </Phone>
  );
}

Object.assign(window, { RedeemCreditsScreen });
