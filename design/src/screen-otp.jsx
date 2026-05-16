// Screen 13 — OTP Verification
// 6-box entry, live countdown, shake-on-error, too-many-attempts lockout.

function OtpScreen() {
  const [digits, setDigits] = useState(['8','3','0','2']);
  const [attempts, setAttempts] = useState(3);
  const [timer, setTimer] = useState(42);
  const [shaking, setShaking] = useState(false);
  const [tooMany, setTooMany] = useState(false);
  const [errorMsg, setErrorMsg] = useState('Incorrect code — 3 attempts remaining');

  useEffect(() => {
    if (timer <= 0) return;
    const id = setInterval(() => setTimer(s => Math.max(0, s - 1)), 1000);
    return () => clearInterval(id);
  }, []);

  const addDigit = (d) => {
    if (tooMany || digits.length >= 6) return;
    const next = [...digits, d];
    setDigits(next);
    if (next.length === 6) {
      setTimeout(() => {
        const rem = attempts - 1;
        if (rem <= 0) {
          setTooMany(true);
          setErrorMsg(null);
          setDigits([]);
        } else {
          setAttempts(rem);
          setErrorMsg(`Incorrect code — ${rem} attempt${rem === 1 ? '' : 's'} remaining`);
          setShaking(true);
          setTimeout(() => { setShaking(false); setDigits([]); }, 620);
        }
      }, 300);
    }
  };

  const backspace = () => {
    if (tooMany) return;
    setErrorMsg(null);
    setDigits(d => d.slice(0, -1));
  };

  const resend = () => {
    if (timer > 0) return;
    setTimer(42);
    setAttempts(3);
    setTooMany(false);
    setDigits([]);
    setErrorMsg(null);
  };

  const sec = `${Math.floor(timer / 60)}:${String(timer % 60).padStart(2, '0')}`;

  return (
    <Phone>
      <style>{`
        @keyframes gz-shake {
          0%,100%{transform:translateX(0)}
          15%{transform:translateX(-6px)}
          35%{transform:translateX(6px)}
          55%{transform:translateX(-4px)}
          75%{transform:translateX(3px)}
          90%{transform:translateX(-2px)}
        }
        @keyframes gz-blink { 0%,100%{opacity:1} 50%{opacity:0} }
      `}</style>

      <TopBar title="Verify your number" onBack={() => {}} />

      <Scroll>
        {/* subhead */}
        <div style={{ textAlign: 'center', padding: '0 8px 24px' }}>
          <div className="gz-body-r" style={{ marginBottom: 4 }}>We sent a 6-digit code to</div>
          <div className="gz-body gz-num" style={{ fontWeight: 700, fontSize: 16 }}>+91 98765 43210</div>
          <button style={{ background: 'transparent', border: 0, marginTop: 10,
            fontSize: 13, fontWeight: 600, color: 'var(--gz-fg)', cursor: 'pointer' }}>
            Wrong number? Change →
          </button>
        </div>

        {/* OTP boxes */}
        <div style={{
          display: 'flex', gap: 8, justifyContent: 'center', marginBottom: 14,
          animation: shaking ? 'gz-shake 0.55s ease' : 'none',
        }}>
          {[0,1,2,3,4,5].map(i => {
            const filled = i < digits.length;
            const active  = i === digits.length && !tooMany;
            const errBox  = shaking || (tooMany && i === 0);
            return (
              <div key={i} style={{
                width: 46, height: 58, borderRadius: 14,
                background: filled ? 'var(--gz-fg)' : 'var(--gz-card)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: 'var(--gz-mono)', fontSize: 26, fontWeight: 700,
                color: filled ? '#fff' : 'var(--gz-fg)',
                boxShadow:
                  errBox  ? 'inset 0 0 0 2px var(--gz-err)' :
                  active  ? 'inset 0 0 0 2px var(--gz-fg)' : 'none',
                transition: 'background .12s, box-shadow .12s',
              }}>
                {filled ? digits[i] : active ? (
                  <span style={{ width: 2, height: 26, background: 'var(--gz-fg)', borderRadius: 1,
                    animation: 'gz-blink 1s step-end infinite' }} />
                ) : null}
              </div>
            );
          })}
        </div>

        {/* attempt counter */}
        {!tooMany && attempts < 4 && (
          <div style={{ textAlign: 'center', marginBottom: 8 }}>
            <span className="gz-small" style={{ color: 'var(--gz-warn)', fontWeight: 700 }}>
              {attempts} attempt{attempts === 1 ? '' : 's'} remaining
            </span>
          </div>
        )}

        {/* error card */}
        {errorMsg && !tooMany && (
          <div style={{
            padding: '12px 14px', borderRadius: 13, marginBottom: 10,
            background: 'var(--gz-err-bg)',
            display: 'flex', alignItems: 'center', gap: 10,
          }}>
            <span style={{ color: 'var(--gz-err)', flex: 1, fontSize: 13, fontWeight: 600 }}>{errorMsg}</span>
            <button onClick={() => setErrorMsg(null)}
              style={{ background: 'transparent', border: 0, color: 'var(--gz-err)', padding: 4, cursor: 'pointer', display: 'flex' }}>
              {React.cloneElement(I.x, { style: { width: 16, height: 16 } })}
            </button>
          </div>
        )}

        {/* too many */}
        {tooMany && (
          <div style={{
            padding: '16px', borderRadius: 13, marginBottom: 10,
            background: 'var(--gz-err-bg)', textAlign: 'center',
          }}>
            <div className="gz-h3" style={{ color: 'var(--gz-err)', marginBottom: 4 }}>Too many attempts</div>
            <div className="gz-small" style={{ color: 'var(--gz-err)', opacity: 0.75 }}>
              Request a new code to continue
            </div>
          </div>
        )}

        <div style={{ textAlign: 'center', marginBottom: 20 }}>
          <span className="gz-small">Code submits automatically</span>
        </div>

        {/* numpad */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginBottom: 20 }}>
          {[1,2,3,4,5,6,7,8,9,'',0,'⌫'].map((k, idx) => (
            <button key={idx}
              onClick={() => k === '⌫' ? backspace() : k !== '' && addDigit(String(k))}
              disabled={tooMany || (k !== '⌫' && k !== '' && digits.length >= 6)}
              style={{
                height: 56, border: 0,
                background: k === '' ? 'transparent' : 'var(--gz-card)',
                borderRadius: 14,
                fontFamily: 'var(--gz-mono)', fontSize: 21, fontWeight: 600,
                color: k === '⌫' ? 'var(--gz-fg-3)' : 'var(--gz-fg)',
                cursor: k === '' ? 'default' : 'pointer',
                opacity: (tooMany && k !== '⌫') ? 0.35 : 1,
                transition: 'opacity .15s',
              }}>{k}</button>
          ))}
        </div>

        {/* resend */}
        <div style={{ textAlign: 'center', marginBottom: 8 }}>
          <span className="gz-small" style={{ marginRight: 4 }}>Didn't get it?</span>
          <button onClick={resend} disabled={timer > 0}
            style={{
              background: 'transparent', border: 0,
              fontSize: 12, fontWeight: 700,
              color: timer > 0 ? 'var(--gz-fg-4)' : 'var(--gz-fg)',
              cursor: timer > 0 ? 'default' : 'pointer',
            }}>
            {timer > 0 ? `Resend in ${sec}` : 'Resend code'}
          </button>
        </div>

        <div style={{ textAlign: 'center', marginTop: 4 }}>
          <button style={{ background: 'transparent', border: 0,
            fontSize: 12, fontWeight: 500, color: 'var(--gz-fg-3)', cursor: 'pointer' }}>
            Having trouble? Contact support
          </button>
        </div>
      </Scroll>
    </Phone>
  );
}

Object.assign(window, { OtpScreen });
