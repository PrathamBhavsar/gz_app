// Screen 8 — Create Dispute
// Form screen. Session picker, reason w/ char counter, amount, summary preview, submit.

const DISPUTE_SESSIONS = [
  { id: 'd1', label: '18 Apr · GameZone Koramangala · RTX 4090', amt: 160 },
  { id: 'd2', label: '12 Apr · GameZone MG Road · PS5',          amt:  90 },
  { id: 'd3', label: '5 Apr · GameZone Koramangala · VR',        amt: 200 },
];

function CreateDisputeScreen() {
  const [sessionId, setSessionId] = useState('d1');
  const [pickerOpen, setPickerOpen] = useState(false);
  const [reason, setReason] = useState('');
  const [amount, setAmount] = useState(160);
  const [notes, setNotes] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const taRef = useRef(null);

  const session = DISPUTE_SESSIONS.find(s => s.id === sessionId);

  // keep amount in sync with the selected session's max
  const pickSession = (id) => {
    setSessionId(id);
    setAmount(DISPUTE_SESSIONS.find(s => s.id === id).amt);
    setPickerOpen(false);
  };

  const valid = reason.trim().length >= 20 && amount > 0 && amount <= session.amt;
  const charCount = reason.length;

  if (submitted) return <DisputeSuccess />;

  return (
    <Phone>
      <TopBar title="File a dispute" subtitle="We've got you" onBack={() => {}} />

      <Scroll>
        {/* explainer */}
        <div className="gz-card" style={{ marginBottom: 14, display: 'flex', gap: 12, alignItems: 'flex-start',
          background: 'var(--gz-info-bg)' }}>
          <div className="gz-tile" style={{ background: 'rgba(255,255,255,0.55)', color: 'var(--gz-info)', flexShrink: 0 }}>
            {React.cloneElement(I.info, { style: { width: 18, height: 18 } })}
          </div>
          <div>
            <div className="gz-h3" style={{ marginBottom: 4, color: 'var(--gz-info)' }}>Reviewed in 2–3 business days</div>
            <div className="gz-body-r" style={{ fontSize: 13, color: 'var(--gz-info)', opacity: 0.85 }}>
              Attach the session that was billed incorrectly. Receipts and logs are pulled automatically.
            </div>
          </div>
        </div>

        {/* session picker */}
        <FormField label="Disputed session" required>
          <button onClick={() => setPickerOpen(o => !o)}
            style={{
              width: '100%', padding: '12px 14px',
              background: 'var(--gz-card)', border: 0, borderRadius: 14,
              display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, textAlign: 'left',
            }}>
            <div style={{ minWidth: 0, flex: 1 }}>
              <div className="gz-body" style={{ fontWeight: 600,
                whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                {session.label}
              </div>
              <div className="gz-small gz-num" style={{ marginTop: 2 }}>₹{session.amt} charged</div>
            </div>
            <span style={{ color: 'var(--gz-fg-3)', transform: pickerOpen ? 'rotate(180deg)' : 'none', transition: 'transform .15s' }}>
              {I.chevDn}
            </span>
          </button>
          {pickerOpen && (
            <div style={{ marginTop: 6, background: 'var(--gz-card)', borderRadius: 14, padding: 4 }}>
              {DISPUTE_SESSIONS.map((s, i) => (
                <button key={s.id} onClick={() => pickSession(s.id)}
                  style={{
                    width: '100%', padding: '10px 12px',
                    border: 0,
                    background: s.id === sessionId ? 'var(--gz-pill-bg)' : 'transparent',
                    borderRadius: 10, textAlign: 'left', cursor: 'pointer',
                    display: 'flex', justifyContent: 'space-between', alignItems: 'center',
                    fontFamily: 'inherit',
                  }}>
                  <span className="gz-body" style={{ fontWeight: s.id === sessionId ? 600 : 500,
                    whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{s.label}</span>
                  <span className="gz-small gz-num" style={{ flexShrink: 0, marginLeft: 8 }}>₹{s.amt}</span>
                </button>
              ))}
            </div>
          )}
        </FormField>

        {/* reason */}
        <FormField label="What happened?" required
          help={
            <span style={{ color: charCount >= 20 ? 'var(--gz-ok)' : (charCount > 0 ? 'var(--gz-warn)' : 'var(--gz-fg-3)') }}>
              <span className="gz-num">{charCount}</span> / 500
            </span>
          }>
          <textarea ref={taRef}
            maxLength={500}
            value={reason}
            onChange={e => setReason(e.target.value)}
            placeholder="Describe what happened — include time, system, and what went wrong"
            style={{
              width: '100%', minHeight: 110, resize: 'none',
              padding: '12px 14px',
              background: 'var(--gz-card)', border: 0, borderRadius: 14,
              fontFamily: 'var(--gz-font)', fontSize: 14, lineHeight: 1.45,
              color: 'var(--gz-fg)', outline: 'none',
              boxShadow: charCount > 0 && charCount < 20 ? 'inset 0 0 0 1.5px var(--gz-warn)' : 'inset 0 0 0 0 transparent',
              transition: 'box-shadow .15s',
            }} />
          {charCount > 0 && charCount < 20 && (
            <div className="gz-small" style={{ marginTop: 6, color: 'var(--gz-warn)' }}>
              At least 20 characters — help us understand what happened
            </div>
          )}
        </FormField>

        {/* amount */}
        <FormField label="Amount disputed" help={`max ₹${session.amt}`}>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 0,
            padding: '0 14px',
            background: 'var(--gz-card)', borderRadius: 14,
          }}>
            <span className="gz-h2" style={{ color: 'var(--gz-fg-3)', fontWeight: 500 }}>₹</span>
            <input type="number" min={0} max={session.amt} value={amount}
              onChange={e => setAmount(Math.max(0, Math.min(session.amt, +e.target.value || 0)))}
              style={{
                flex: 1, padding: '14px 8px',
                background: 'transparent', border: 0, outline: 'none',
                fontFamily: 'var(--gz-mono)', fontSize: 18, fontWeight: 700,
                color: 'var(--gz-fg)',
              }} />
            <button onClick={() => setAmount(session.amt)} style={{
              padding: '6px 10px', background: 'var(--gz-pill-bg)', border: 0,
              borderRadius: 8, fontSize: 11, fontWeight: 600,
              fontFamily: 'inherit', cursor: 'pointer',
            }}>Full</button>
          </div>
        </FormField>

        {/* notes */}
        <FormField label="Additional notes">
          <input type="text" value={notes} onChange={e => setNotes(e.target.value)}
            placeholder="Any extra context for the reviewer"
            style={{
              width: '100%', padding: '14px',
              background: 'var(--gz-card)', border: 0, borderRadius: 14,
              fontFamily: 'var(--gz-font)', fontSize: 14, color: 'var(--gz-fg)', outline: 'none',
            }} />
        </FormField>

        {/* summary preview */}
        <div className="gz-card gz-card--tint" style={{ marginTop: 6 }}>
          <div className="gz-meta" style={{ marginBottom: 10, color: 'var(--gz-fg-2)' }}>SUMMARY PREVIEW</div>
          <MetaRow label="Session" value={session.label.split(' · ')[0]} />
          <MetaRow label="Store"   value={session.label.split(' · ')[1] || '—'} />
          <MetaRow label="System"  value={session.label.split(' · ')[2] || '—'} />
          <MetaRow label="Disputing" value={<span className="gz-num">₹{amount} of ₹{session.amt}</span>} />
          <div style={{ marginTop: 10, padding: '10px 12px',
            background: 'rgba(255,255,255,0.55)', borderRadius: 10,
            fontSize: 12, color: 'var(--gz-fg-2)', lineHeight: 1.4,
            minHeight: 38,
          }}>
            <span className="gz-meta" style={{ color: 'var(--gz-fg-3)', marginBottom: 4, display: 'block' }}>REASON</span>
            {reason.trim() ? (reason.slice(0, 80) + (reason.length > 80 ? '…' : '')) : <span style={{ opacity: 0.5 }}>Add a reason above</span>}
          </div>
        </div>
      </Scroll>

      {/* sticky bottom */}
      <div style={{ padding: '12px 16px 22px', background: 'var(--gz-bg)', flexShrink: 0,
        boxShadow: '0 -8px 16px -8px rgba(0,0,0,0.04)' }}>
        <button className="gz-btn" disabled={!valid}
          onClick={() => setSubmitted(true)}>
          Submit dispute
        </button>
        <div className="gz-small" style={{ textAlign: 'center', marginTop: 8 }}>
          Need help first?{' '}
          <span style={{ color: 'var(--gz-fg)', fontWeight: 600, textDecoration: 'underline' }}>
            Contact support
          </span>
        </div>
      </div>
    </Phone>
  );
}

function FormField({ label, required, help, children }) {
  return (
    <div style={{ marginBottom: 14 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 4px 8px' }}>
        <span className="gz-meta">
          {label}
          {required && <span style={{ color: 'var(--gz-err)', marginLeft: 4 }}>*</span>}
        </span>
        {help && <span className="gz-small gz-num">{help}</span>}
      </div>
      {children}
    </div>
  );
}

function DisputeSuccess() {
  return (
    <Phone>
      <TopBar title="Submitted" onBack={() => {}} />
      <div style={{ flex: 1, padding: '40px 24px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}>
        <div style={{
          width: 80, height: 80, borderRadius: 999,
          background: 'var(--gz-card-tint)', color: 'var(--gz-ok)',
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          marginBottom: 24,
          animation: 'gz-slide-up 0.3s cubic-bezier(.2,.7,.3,1)',
        }}>
          {React.cloneElement(I.check, { style: { width: 36, height: 36, strokeWidth: 2.4 } })}
        </div>
        <h2 className="gz-title" style={{ marginBottom: 10 }}>Dispute filed</h2>
        <div className="gz-body-r" style={{ maxWidth: 280, marginBottom: 32 }}>
          We've assigned dispute <span className="gz-num" style={{ color: 'var(--gz-fg)', fontWeight: 600 }}>#DIS-0043</span>.
          You'll hear back in 2–3 business days.
        </div>
        <button className="gz-btn" style={{ maxWidth: 240 }}>
          View dispute {I.chev}
        </button>
        <button className="gz-btn gz-btn--ghost" style={{ maxWidth: 240, marginTop: 8 }}>
          Back to wallet
        </button>
      </div>
    </Phone>
  );
}

Object.assign(window, { CreateDisputeScreen });
