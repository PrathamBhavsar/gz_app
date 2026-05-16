// Screen 15 — Auth Landing + Register (two-step flow)
// Step 1: full-screen landing. Step 2: registration form with password strength + terms.

function AuthScreen() {
  const [step, setStep]         = useState(1);
  const [name, setName]         = useState('');
  const [phone, setPhone]       = useState('');
  const [email, setEmail]       = useState('');
  const [password, setPassword] = useState('');
  const [showPw, setShowPw]     = useState(false);
  const [terms, setTerms]       = useState(false);
  const [nameBlurred, setNameBlurred] = useState(false);

  const pwLevel = password.length === 0 ? -1
    : password.length < 6  ? 0
    : password.length < 10 ? 1
    : password.length < 14 ? 2 : 3;
  const pwLabels = ['Weak', 'Fair', 'Good', 'Strong'];
  const pwColors = ['var(--gz-err)', 'var(--gz-warn)', 'oklch(0.58 0.14 100)', 'var(--gz-ok)'];

  const nameInvalid = nameBlurred && name.trim().length < 2;
  const canContinue = name.trim().length >= 2 && (phone.length >= 10 || email.includes('@')) && terms;

  const eyeIc = (
    <svg viewBox="0 0 24 24" className="gz-ic">
      {showPw
        ? <><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="2.5"/><path d="M3 3l18 18"/></>
        : <><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="2.5"/></>
      }
    </svg>
  );

  const googleIc = (
    <svg width="18" height="18" viewBox="0 0 24 24">
      <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
      <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
      <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18A10.99 10.99 0 001 12c0 1.78.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
      <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
    </svg>
  );

  const appleIc = (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="white">
      <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.7 9.05 7.4c1.32.07 2.21.7 2.98.73.91-.17 1.79-.82 2.79-.74 1.21.1 2.11.58 2.73 1.44-2.49 1.5-1.9 4.8.4 5.73-.46 1.28-1.08 2.52-1.9 3.72zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
    </svg>
  );

  const fieldInput = (props) => ({
    width: '100%', padding: '14px 14px',
    background: 'var(--gz-card)', border: 0, borderRadius: 14, outline: 'none',
    fontFamily: 'var(--gz-font)', fontSize: 15, fontWeight: 500, color: 'var(--gz-fg)',
    ...props,
  });

  return (
    <Phone>
      <div style={{ position: 'relative', flex: 1, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>

        {/* ── Step 1: Landing ── */}
        <div style={{
          position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
          transform: step === 1 ? 'translateX(0)' : 'translateX(-30%)',
          opacity: step === 1 ? 1 : 0,
          transition: 'transform .35s cubic-bezier(.2,.7,.3,1), opacity .25s',
          pointerEvents: step === 1 ? 'auto' : 'none',
          background: 'var(--gz-bg)',
        }}>
          {/* ambient glow */}
          <div style={{
            position: 'absolute', inset: 0, pointerEvents: 'none',
            background: `
              radial-gradient(ellipse 260px 200px at 25% 22%, oklch(0.90 0.06 145) 0%, transparent 70%),
              radial-gradient(ellipse 200px 160px at 80% 68%, oklch(0.90 0.05 270) 0%, transparent 70%)
            `,
          }} />

          <div style={{ position: 'relative', flex: 1, display: 'flex', flexDirection: 'column',
            padding: '0 24px 28px' }}>
            {/* logo + tagline */}
            <div style={{ flex: 1, display: 'flex', flexDirection: 'column',
              alignItems: 'center', justifyContent: 'center', paddingTop: 16 }}>
              <div style={{
                width: 72, height: 72, borderRadius: 20,
                background: 'var(--gz-fg)', color: 'var(--gz-card-tint-strong)',
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: 'var(--gz-mono)', fontSize: 30, fontWeight: 700, letterSpacing: '-0.04em',
                marginBottom: 18,
              }}>GZ</div>
              <div className="gz-title" style={{ textAlign: 'center', marginBottom: 8 }}>Game on.</div>
              <div className="gz-body-r" style={{ textAlign: 'center', maxWidth: 210, lineHeight: 1.5 }}>
                Book systems, track sessions, earn credits.
              </div>
            </div>

            {/* auth options */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              <button className="gz-btn" onClick={() => setStep(2)}
                style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10 }}>
                {React.cloneElement(I.phone, { style: { width: 18, height: 18 } })}
                Continue with Phone
              </button>
              <button className="gz-btn gz-btn--ghost"
                style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10 }}>
                <svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 18, height: 18 }}>
                  <rect x="3" y="5" width="18" height="14" rx="2"/>
                  <path d="M3 9l9 6 9-6"/>
                </svg>
                Continue with Email
              </button>

              <div style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '2px 0' }}>
                <hr className="gz-hr" style={{ flex: 1 }} />
                <span className="gz-small">or</span>
                <hr className="gz-hr" style={{ flex: 1 }} />
              </div>

              <div style={{ display: 'flex', gap: 10, justifyContent: 'center' }}>
                <button style={{
                  width: 50, height: 50, border: 0, borderRadius: 14,
                  background: '#fff', boxShadow: 'inset 0 0 0 1px var(--gz-rule)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  cursor: 'pointer',
                }}>{googleIc}</button>

                <button style={{
                  width: 50, height: 50, border: 0, borderRadius: 14,
                  background: '#0A0A0A',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  cursor: 'pointer',
                }}>{appleIc}</button>
              </div>
            </div>

            <div style={{ textAlign: 'center', marginTop: 16 }}>
              <span className="gz-small">Already have an account? </span>
              <button style={{ background: 'transparent', border: 0, fontSize: 12,
                fontWeight: 700, color: 'var(--gz-fg)', cursor: 'pointer' }}>Sign in</button>
            </div>
            <div style={{ textAlign: 'center', marginTop: 8 }}>
              <span className="gz-small" style={{ fontSize: 10, color: 'var(--gz-fg-4)' }}>
                By continuing you agree to our{' '}
              </span>
              <button style={{ background: 'transparent', border: 0, fontSize: 10,
                fontWeight: 600, color: 'var(--gz-fg-3)', cursor: 'pointer', textDecoration: 'underline' }}>
                Terms &amp; Privacy Policy
              </button>
            </div>
          </div>
        </div>

        {/* ── Step 2: Register ── */}
        <div style={{
          position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
          transform: step === 2 ? 'translateX(0)' : 'translateX(100%)',
          transition: 'transform .35s cubic-bezier(.2,.7,.3,1)',
          background: 'var(--gz-bg)',
        }}>
          <div style={{ padding: '8px 16px 10px', display: 'grid',
            gridTemplateColumns: '40px 1fr 40px', alignItems: 'center', flexShrink: 0 }}>
            <IconBtn onClick={() => setStep(1)}>{I.back}</IconBtn>
            <div className="gz-h2" style={{ textAlign: 'center' }}>Create account</div>
            <div />
          </div>

          {/* progress */}
          <div style={{ padding: '0 16px 14px', flexShrink: 0 }}>
            <div style={{ display: 'flex', gap: 5 }}>
              {[1,2,3].map(n => (
                <div key={n} style={{ flex: 1, height: 4, borderRadius: 999,
                  background: n === 1 ? 'var(--gz-fg)' : 'var(--gz-rule)',
                  transition: 'background .2s' }} />
              ))}
            </div>
            <div className="gz-small" style={{ marginTop: 7, color: 'var(--gz-fg-3)' }}>
              Step 1 of 3 — Your details
            </div>
          </div>

          <Scroll>
            {/* Full Name */}
            <AuthRegField label="Full Name" required>
              <div style={{
                borderRadius: 14,
                boxShadow: nameInvalid ? 'inset 0 0 0 1.5px var(--gz-err)' : 'none',
                transition: 'box-shadow .15s',
              }}>
                <input type="text" value={name}
                  onChange={e => setName(e.target.value)}
                  onBlur={() => setNameBlurred(true)}
                  placeholder="Pratham Mehta"
                  style={fieldInput({})} />
              </div>
              {nameInvalid && (
                <div className="gz-small" style={{ marginTop: 6, color: 'var(--gz-err)', paddingLeft: 4 }}>
                  Name must be at least 2 characters
                </div>
              )}
            </AuthRegField>

            {/* Phone */}
            <AuthRegField label="Phone number" required>
              <div style={{ display: 'flex', background: 'var(--gz-card)', borderRadius: 14, overflow: 'hidden' }}>
                <div style={{ padding: '14px 14px', borderRight: '1px solid var(--gz-rule)',
                  display: 'flex', alignItems: 'center', gap: 6, flexShrink: 0 }}>
                  <span style={{ fontSize: 16 }}>🇮🇳</span>
                  <span className="gz-body gz-num" style={{ fontWeight: 700 }}>+91</span>
                </div>
                <input type="tel" value={phone}
                  onChange={e => setPhone(e.target.value.replace(/\D/g, '').slice(0, 10))}
                  placeholder="98765 43210"
                  style={fieldInput({ background: 'transparent', borderRadius: 0, flex: 1, minWidth: 0 })} />
              </div>
            </AuthRegField>

            {/* Email */}
            <AuthRegField label="Email" note="optional">
              <input type="email" value={email}
                onChange={e => setEmail(e.target.value)}
                placeholder="name@email.com  (optional)"
                style={fieldInput({})} />
            </AuthRegField>

            {/* Password */}
            <AuthRegField label="Password" required>
              <div style={{ position: 'relative' }}>
                <input type={showPw ? 'text' : 'password'} value={password}
                  onChange={e => setPassword(e.target.value)}
                  placeholder="At least 8 characters"
                  style={fieldInput({ paddingRight: 48 })} />
                <button onClick={() => setShowPw(s => !s)}
                  style={{ position: 'absolute', right: 12, top: '50%', transform: 'translateY(-50%)',
                    background: 'transparent', border: 0, color: 'var(--gz-fg-3)',
                    cursor: 'pointer', padding: 4, display: 'flex', alignItems: 'center' }}>
                  {eyeIc}
                </button>
              </div>
              {pwLevel >= 0 && (
                <div style={{ marginTop: 8 }}>
                  <div style={{ display: 'flex', gap: 4, marginBottom: 5 }}>
                    {[0,1,2,3].map(i => (
                      <div key={i} style={{
                        flex: 1, height: 4, borderRadius: 999,
                        background: i <= pwLevel ? pwColors[pwLevel] : 'var(--gz-rule)',
                        transition: 'background .2s',
                      }} />
                    ))}
                  </div>
                  <span className="gz-small" style={{ color: pwColors[pwLevel], fontWeight: 700 }}>
                    {pwLabels[pwLevel]}
                  </span>
                </div>
              )}
            </AuthRegField>

            <div className="gz-small" style={{ padding: '0 4px 16px', color: 'var(--gz-fg-4)' }}>
              At least one of phone or email required
            </div>

            {/* Terms */}
            <div onClick={() => setTerms(t => !t)}
              style={{ display: 'flex', gap: 12, alignItems: 'flex-start',
                padding: '14px 16px', background: 'var(--gz-card)', borderRadius: 14,
                marginBottom: 16, cursor: 'pointer' }}>
              <div style={{
                width: 22, height: 22, borderRadius: 7, flexShrink: 0, marginTop: 1,
                background: terms ? 'var(--gz-fg)' : 'transparent',
                border: `2px solid ${terms ? 'var(--gz-fg)' : 'var(--gz-rule)'}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                transition: 'all .15s',
              }}>
                {terms && (
                  <svg viewBox="0 0 24 24" className="gz-ic"
                    style={{ width: 14, height: 14, color: '#fff', strokeWidth: 3 }}>
                    <path d="M5 12l5 5L20 7"/>
                  </svg>
                )}
              </div>
              <span className="gz-body" style={{ fontSize: 13, color: 'var(--gz-fg-2)', lineHeight: 1.5 }}>
                I agree to the{' '}
                <span style={{ color: 'var(--gz-fg)', fontWeight: 700, textDecoration: 'underline' }}>Terms of Service</span>
                {' and '}
                <span style={{ color: 'var(--gz-fg)', fontWeight: 700, textDecoration: 'underline' }}>Privacy Policy</span>
              </span>
            </div>

            <button className="gz-btn" disabled={!canContinue} style={{ marginBottom: 14 }}>
              Continue →
            </button>

            <div style={{ textAlign: 'center', marginBottom: 8 }}>
              <span className="gz-small">Already have an account? </span>
              <button style={{ background: 'transparent', border: 0, fontSize: 12,
                fontWeight: 700, color: 'var(--gz-fg)', cursor: 'pointer' }}>Sign in</button>
            </div>
          </Scroll>
        </div>
      </div>
    </Phone>
  );
}

function AuthRegField({ label, required, note, children }) {
  return (
    <div style={{ marginBottom: 14 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '0 4px 8px' }}>
        <span className="gz-meta">{label}</span>
        {required && <span style={{ color: 'var(--gz-err)', fontSize: 11 }}>*</span>}
        {note && <span className="gz-small" style={{ color: 'var(--gz-fg-4)', marginLeft: 'auto' }}>{note}</span>}
      </div>
      {children}
    </div>
  );
}

Object.assign(window, { AuthScreen });
