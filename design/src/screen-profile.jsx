// Screen 10 — Edit Profile
// Field validation, email verification state, phone OTP sheet, save flow.

function EditProfileScreen() {
  const original = { name: 'Pratham Mehta', email: 'pratham@gmail.com', phone: '+91 98765 43210' };
  const [name, setName] = useState(original.name);
  const [email, setEmail] = useState(original.email);
  const [phone, setPhone] = useState(original.phone);
  const [phoneSheet, setPhoneSheet] = useState(false);
  const [newPhone, setNewPhone] = useState('');
  const [otpStep, setOtpStep] = useState(0); // 0 input · 1 otp
  const [otp, setOtp] = useState('');
  const [saving, setSaving] = useState(false);
  const [savedToast, setSavedToast] = useState(false);
  const [delConfirm, setDelConfirm] = useState(false);
  const [photoTip, setPhotoTip] = useState(false);

  const dirty =
    name !== original.name ||
    email !== original.email ||
    phone !== original.phone;
  const nameInvalid = name.trim().length < 2;
  const emailChanged = email !== original.email;
  const canSave = dirty && !nameInvalid;

  const onSave = () => {
    if (!canSave) return;
    setSaving(true);
    setTimeout(() => {
      setSaving(false);
      setSavedToast(true);
      setTimeout(() => setSavedToast(false), 2200);
    }, 850);
  };

  return (
    <Phone>
      <div style={{ display: 'grid', gridTemplateColumns: '40px 1fr 64px', alignItems: 'center', padding: '8px 16px 12px', flexShrink: 0 }}>
        <IconBtn>{I.back}</IconBtn>
        <h1 className="gz-h2" style={{ textAlign: 'center' }}>Edit profile</h1>
        <button onClick={onSave} disabled={!canSave || saving}
          style={{ background: 'transparent', border: 0, padding: 4,
            fontSize: 13, fontWeight: 700, color: canSave ? 'var(--gz-fg)' : 'var(--gz-fg-4)',
            textAlign: 'right',
            cursor: canSave ? 'pointer' : 'default',
          }}>
          {saving ? <Spinner /> : 'Save'}
        </button>
      </div>

      <Scroll>
        {/* avatar */}
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '12px 0 24px' }}>
          <div style={{
            width: 88, height: 88, borderRadius: 999,
            background: 'var(--gz-card-tint)', color: 'var(--gz-fg)',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 34, fontWeight: 700, letterSpacing: '-0.04em',
            fontFamily: 'var(--gz-font)',
            marginBottom: 12,
          }}>
            {name.trim().split(/\s+/).map(w => w[0]).slice(0, 2).join('').toUpperCase() || 'P'}
          </div>
          <button onMouseEnter={() => setPhotoTip(true)} onMouseLeave={() => setPhotoTip(false)}
            onClick={() => setPhotoTip(t => !t)}
            style={{
              background: 'transparent', border: 0, padding: 4,
              fontSize: 13, fontWeight: 600, color: 'var(--gz-fg-4)',
              cursor: 'help', position: 'relative',
            }}>
            Change photo
            {photoTip && (
              <div style={{
                position: 'absolute', top: 'calc(100% + 6px)', left: '50%', transform: 'translateX(-50%)',
                padding: '6px 10px',
                background: 'var(--gz-fg)', color: '#fff',
                borderRadius: 8, fontSize: 11, fontWeight: 500,
                whiteSpace: 'nowrap',
                animation: 'gz-fade 0.15s ease-out',
              }}>Coming soon</div>
            )}
          </button>
        </div>

        {/* form */}
        <ProfileField label="Full name" required>
          <div style={{
            background: 'var(--gz-card)', borderRadius: 14,
            boxShadow: nameInvalid && name.length > 0 ? 'inset 0 0 0 1.5px var(--gz-err)' : 'inset 0 0 0 0',
            transition: 'box-shadow .15s',
          }}>
            <input type="text" value={name} onChange={e => setName(e.target.value)}
              style={{
                width: '100%', padding: '14px',
                background: 'transparent', border: 0, outline: 'none',
                fontFamily: 'var(--gz-font)', fontSize: 15, fontWeight: 500,
                color: 'var(--gz-fg)',
              }} />
          </div>
          {nameInvalid && name.length > 0 && (
            <div className="gz-small" style={{ marginTop: 6, color: 'var(--gz-err)' }}>
              Name must be at least 2 characters
            </div>
          )}
        </ProfileField>

        <ProfileField label="Email">
          <div style={{
            display: 'flex', alignItems: 'center', gap: 10,
            background: 'var(--gz-card)', borderRadius: 14, padding: '0 14px 0 0',
          }}>
            <input type="email" value={email} onChange={e => setEmail(e.target.value)}
              style={{
                flex: 1, padding: '14px',
                background: 'transparent', border: 0, outline: 'none',
                fontFamily: 'var(--gz-font)', fontSize: 15, fontWeight: 500,
                color: 'var(--gz-fg)', minWidth: 0,
              }} />
            {emailChanged
              ? <button onClick={() => {}} style={{
                  background: 'var(--gz-warn-bg)', color: 'var(--gz-warn)',
                  border: 0, borderRadius: 999, padding: '5px 10px',
                  fontSize: 11, fontWeight: 600, fontFamily: 'inherit',
                  whiteSpace: 'nowrap',
                }}>Resend verification</button>
              : <span className="gz-tag gz-tag--ok" style={{ flexShrink: 0 }}>
                  <svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 12, height: 12, strokeWidth: 2.4 }}><path d="M5 12l5 5L20 7"/></svg>
                  Verified
                </span>}
          </div>
        </ProfileField>

        <ProfileField label="Phone">
          <button onClick={() => { setPhoneSheet(true); setOtpStep(0); setNewPhone(''); setOtp(''); }}
            style={{
              width: '100%', padding: '14px',
              background: 'var(--gz-card)', border: 0, borderRadius: 14, textAlign: 'left',
              display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 10,
            }}>
            <span style={{ display: 'flex', alignItems: 'center', gap: 10, flex: 1, minWidth: 0 }}>
              <span style={{ color: 'var(--gz-fg-3)' }}>
                {React.cloneElement(I.phone, { style: { width: 16, height: 16 } })}
              </span>
              <span className="gz-body gz-num" style={{ fontWeight: 600 }}>{phone}</span>
            </span>
            <span style={{ fontSize: 12, fontWeight: 700, color: 'var(--gz-fg)' }}>Change →</span>
          </button>
        </ProfileField>

        <ProfileField label="Member since">
          <div style={{
            padding: '14px',
            background: 'var(--gz-pill-bg)', borderRadius: 14,
            display: 'flex', alignItems: 'center', gap: 10,
            color: 'var(--gz-fg-3)',
          }}>
            {React.cloneElement(I.cal, { style: { width: 16, height: 16 } })}
            <span className="gz-body" style={{ fontWeight: 500 }}>March 2024</span>
            <Tag kind="mute">Read-only</Tag>
          </div>
        </ProfileField>

        {/* delete */}
        <div style={{ padding: '24px 4px 0', textAlign: 'center' }}>
          <button onClick={() => setDelConfirm(true)}
            style={{ background: 'transparent', border: 0, padding: 8,
              fontSize: 13, fontWeight: 600, color: 'var(--gz-err)',
              cursor: 'pointer', textDecoration: 'underline',
            }}>
            Delete account
          </button>
        </div>
      </Scroll>

      {/* phone change sheet */}
      {phoneSheet && (
        <div className="gz-sheet-overlay" onClick={() => setPhoneSheet(false)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()} style={{ paddingBottom: 24 }}>
            <div className="gz-sheet__grab" />
            {otpStep === 0 ? (
              <>
                <div className="gz-h1" style={{ marginBottom: 6 }}>Change phone</div>
                <div className="gz-body-r" style={{ marginBottom: 18 }}>
                  We'll send an OTP to your new number to verify.
                </div>
                <ProfileField label="New phone number">
                  <div style={{
                    display: 'flex', alignItems: 'center',
                    background: 'var(--gz-pill-bg)', borderRadius: 14, padding: '0 14px',
                  }}>
                    <span className="gz-body gz-num" style={{ fontWeight: 600, color: 'var(--gz-fg-3)' }}>+91</span>
                    <input value={newPhone} onChange={e => setNewPhone(e.target.value.replace(/[^\d ]/g, '').slice(0, 11))}
                      placeholder="98765 43210"
                      style={{
                        flex: 1, padding: '14px 8px',
                        background: 'transparent', border: 0, outline: 'none',
                        fontFamily: 'var(--gz-mono)', fontSize: 16, fontWeight: 600,
                        color: 'var(--gz-fg)', minWidth: 0,
                      }} />
                  </div>
                </ProfileField>
                <button className="gz-btn" disabled={newPhone.replace(/\s/g, '').length < 10}
                  onClick={() => setOtpStep(1)}>Send OTP</button>
              </>
            ) : (
              <>
                <div className="gz-h1" style={{ marginBottom: 6 }}>Enter OTP</div>
                <div className="gz-body-r" style={{ marginBottom: 18 }}>
                  Sent to <span className="gz-num" style={{ color: 'var(--gz-fg)', fontWeight: 600 }}>+91 {newPhone}</span>
                </div>
                <div style={{ display: 'flex', gap: 8, marginBottom: 16, justifyContent: 'center' }}>
                  {[0, 1, 2, 3, 4, 5].map(i => (
                    <div key={i} style={{
                      width: 42, height: 52, borderRadius: 12,
                      background: 'var(--gz-pill-bg)',
                      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                      fontFamily: 'var(--gz-mono)', fontSize: 20, fontWeight: 700,
                      boxShadow: otp.length === i ? 'inset 0 0 0 2px var(--gz-fg)' : 'none',
                    }}>{otp[i] || ''}</div>
                  ))}
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 6, marginBottom: 14 }}>
                  {[1,2,3,4,5,6,7,8,9,'',0,'⌫'].map((k, i) => (
                    <button key={i} onClick={() => {
                      if (k === '') return;
                      if (k === '⌫') setOtp(o => o.slice(0, -1));
                      else if (otp.length < 6) setOtp(o => o + k);
                    }}
                      style={{
                        height: 44, border: 0,
                        background: k === '' ? 'transparent' : 'var(--gz-pill-bg)',
                        borderRadius: 12, fontFamily: 'var(--gz-mono)', fontSize: 18, fontWeight: 600,
                        color: 'var(--gz-fg)', cursor: k === '' ? 'default' : 'pointer',
                      }}>{k}</button>
                  ))}
                </div>
                <button className="gz-btn" disabled={otp.length < 6}
                  onClick={() => {
                    setPhone('+91 ' + newPhone);
                    setPhoneSheet(false);
                  }}>Verify and update</button>
              </>
            )}
          </div>
        </div>
      )}

      {/* delete confirm */}
      {delConfirm && (
        <div className="gz-sheet-overlay" onClick={() => setDelConfirm(false)}
          style={{ alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <div onClick={e => e.stopPropagation()} style={{
            background: 'var(--gz-card)', borderRadius: 22, padding: 22,
            maxWidth: 320, width: '100%',
            animation: 'gz-slide-up 0.18s cubic-bezier(.2,.7,.3,1)',
          }}>
            <div style={{
              width: 40, height: 40, borderRadius: 999,
              background: 'var(--gz-err-bg)', color: 'var(--gz-err)',
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
              marginBottom: 14,
            }}>{React.cloneElement(I.warnT, { style: { width: 20, height: 20 } })}</div>
            <div className="gz-h1" style={{ marginBottom: 6 }}>Delete account?</div>
            <div className="gz-body-r" style={{ marginBottom: 18 }}>
              This permanently deletes your account, bookings, and credit history. Cannot be undone.
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <button className="gz-btn gz-btn--ghost" onClick={() => setDelConfirm(false)}>
                Keep account
              </button>
              <button className="gz-btn" style={{ background: 'var(--gz-err)' }}
                onClick={() => setDelConfirm(false)}>
                Delete
              </button>
            </div>
          </div>
        </div>
      )}

      {/* saved toast */}
      {savedToast && (
        <div style={{
          position: 'absolute', left: 16, right: 16, bottom: 24,
          padding: '12px 16px', borderRadius: 14,
          background: 'var(--gz-fg)', color: '#fff',
          display: 'flex', alignItems: 'center', gap: 10,
          animation: 'gz-slide-up 0.18s cubic-bezier(.2,.7,.3,1)',
          zIndex: 80,
        }}>
          <span style={{ color: 'var(--gz-card-tint-strong)' }}>
            {React.cloneElement(I.check, { style: { width: 18, height: 18 } })}
          </span>
          <span style={{ fontSize: 13, fontWeight: 600 }}>Profile updated</span>
        </div>
      )}
    </Phone>
  );
}

function ProfileField({ label, required, children }) {
  return (
    <div style={{ marginBottom: 14 }}>
      <div className="gz-meta" style={{ padding: '0 4px 8px' }}>
        {label}
        {required && <span style={{ color: 'var(--gz-err)', marginLeft: 4 }}>*</span>}
      </div>
      {children}
    </div>
  );
}

function Spinner() {
  return (
    <span style={{ display: 'inline-block', width: 14, height: 14,
      border: '2px solid var(--gz-fg-4)', borderTopColor: 'var(--gz-fg)',
      borderRadius: 999, animation: 'gz-spin 0.7s linear infinite',
    }}>
      <style>{`@keyframes gz-spin { to { transform: rotate(360deg); } }`}</style>
    </span>
  );
}

Object.assign(window, { EditProfileScreen });
