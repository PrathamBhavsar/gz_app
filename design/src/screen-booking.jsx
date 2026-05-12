// Screen 1 — Booking Summary
// Final confirm before player pays. Campaigns, credits slider, payment grid, sticky CTA.

function BookingSummaryScreen() {
  const [campSel, setCampSel]   = useState('happy');           // 'happy' | 'first' | null
  const [credits, setCredits]   = useState(300);               // 0..850
  const [pay, setPay]           = useState('upi');             // cash/upi/card/credits
  const [openCamp, setOpenCamp] = useState(true);
  const [openCred, setOpenCred] = useState(true);
  const [confirmed, setConfirmed] = useState(false);

  const base = 160;
  const peak = 20;
  const subtotal = base + peak;

  const campMap = {
    happy:  { label: 'Happy Hour — 30%',     amount: 54 },
    first:  { label: 'First Visit Bonus',    amount: 30 },
  };
  const campAmt = campSel && campMap[campSel] ? campMap[campSel].amount : 0;
  const credAmt = credits / 10;          // 10 credits = ₹1
  const total = Math.max(0, subtotal - campAmt - credAmt);

  return (
    <Phone>
      <TopBar title="Confirm booking" subtitle="GameZone · Koramangala"
        trailing={<IconBtn>{I.info}</IconBtn>} onBack={() => {}} />

      <Scroll>
        {/* booking summary */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', marginBottom: 14 }}>
            <div style={{ display: 'flex', gap: 12 }}>
              <div className="gz-tile gz-tile--sq" style={{ width: 44, height: 44, background: 'var(--gz-fg)', color: '#fff' }}>
                {React.cloneElement(I.pc, { style: { width: 22, height: 22 } })}
              </div>
              <div>
                <div className="gz-h2">RTX 4090 Gaming PC</div>
                <div className="gz-small" style={{ marginTop: 4 }}>Seat 3 · PC station</div>
              </div>
            </div>
            <span className="gz-meta">SLOT</span>
          </div>

          <div style={{ display: 'flex', gap: 8, padding: '12px', background: 'var(--gz-pill-bg)', borderRadius: 14 }}>
            <div style={{ flex: 1 }}>
              <div className="gz-meta" style={{ marginBottom: 6 }}>DATE</div>
              <div className="gz-body" style={{ fontWeight: 600 }}>Sat, 18 Apr</div>
            </div>
            <div style={{ width: 1, background: 'var(--gz-rule)' }} />
            <div style={{ flex: 1.4 }}>
              <div className="gz-meta" style={{ marginBottom: 6 }}>TIME</div>
              <div className="gz-body" style={{ fontWeight: 600 }}>4:00 – 6:00 PM</div>
            </div>
            <div style={{ width: 1, background: 'var(--gz-rule)' }} />
            <div style={{ flex: 0.9, textAlign: 'right' }}>
              <div className="gz-meta" style={{ marginBottom: 6 }}>DURATION</div>
              <div className="gz-body gz-num" style={{ fontWeight: 600 }}>2h</div>
            </div>
          </div>
        </div>

        {/* price breakdown so far */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 10 }}>BASE</div>
          <MetaRow label="₹80/hr × 2 hrs" value="₹160" />
          <MetaRow label="Peak hour surcharge" value="+ ₹20" />
          <hr className="gz-hr" style={{ margin: '8px 0' }} />
          <MetaRow label="Subtotal" value={`₹${subtotal}`} valueClass="" />
        </div>

        {/* campaigns */}
        <div style={{ marginBottom: 12 }}>
          <Collapse title="Apply campaign" open={openCamp} onToggle={() => setOpenCamp(o => !o)}
            right={campSel ? <Tag kind="ok">−₹{campAmt}</Tag> : <span className="gz-small">Optional</span>}>
            <div className="gz-hscroll" style={{ margin: 0, padding: '2px 0 4px' }}>
              <CampaignCard
                title="Happy Hour" subtitle="30% off · Mon–Fri 10–2"
                tag={<Tag kind="ok">Eligible</Tag>}
                selected={campSel === 'happy'}
                onClick={() => setCampSel(campSel === 'happy' ? null : 'happy')} />
              <CampaignCard
                title="First Visit Bonus" subtitle="200 credits awarded"
                tag={<Tag kind="info">Applied</Tag>}
                selected={campSel === 'first'}
                onClick={() => setCampSel(campSel === 'first' ? null : 'first')} />
              <CampaignCard
                title="Weekend Special" subtitle="15% off · Sat–Sun"
                tag={<Tag kind="mute">Not met</Tag>}
                disabled />
            </div>
          </Collapse>
        </div>

        {/* credits */}
        <div style={{ marginBottom: 12 }}>
          <Collapse title="Use credits" open={openCred} onToggle={() => setOpenCred(o => !o)}
            right={credits > 0 ? <Tag kind="ok">−₹{credAmt.toFixed(0)}</Tag> : <span className="gz-small">850 available</span>}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 10 }}>
              <span className="gz-small">Balance · GameZone Koramangala</span>
              <span className="gz-body gz-num" style={{ fontWeight: 600 }}>850 credits</span>
            </div>
            <input className="gz-slider" type="range" min="0" max="850" step="10"
              value={credits} onChange={e => setCredits(+e.target.value)} />
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 12 }}>
              <span className="gz-body" style={{ fontWeight: 600 }}>
                <span className="gz-num">{credits}</span> credits
              </span>
              <span className="gz-body" style={{ fontWeight: 600, color: 'var(--gz-ok)' }}>
                = ₹{credAmt.toFixed(0)} off
              </span>
            </div>
            <div style={{
              marginTop: 12, padding: '10px 12px',
              background: 'var(--gz-warn-bg)', color: 'var(--gz-warn)',
              borderRadius: 10, fontSize: 12, fontWeight: 500,
              display: 'flex', gap: 8, alignItems: 'center',
            }}>
              {React.cloneElement(I.info, { style: { width: 14, height: 14, flexShrink: 0 } })}
              Credits valid at this store only
            </div>
          </Collapse>
        </div>

        {/* total card */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <MetaRow label="Subtotal" value={`₹${subtotal}`} />
          {campAmt > 0 && <MetaRow label={`Campaign · ${campMap[campSel].label}`} value={<span style={{ color: 'var(--gz-ok)' }}>− ₹{campAmt}</span>} />}
          {credAmt > 0 && <MetaRow label={`Credits · ${credits}`}  value={<span style={{ color: 'var(--gz-ok)' }}>− ₹{credAmt.toFixed(0)}</span>} />}
          <hr className="gz-hr gz-hr--thick" style={{ margin: '10px 0' }} />
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <span className="gz-h2">Total</span>
            <span className="gz-hero-md">₹{total.toFixed(0)}</span>
          </div>
        </div>

        {/* payment grid */}
        <div className="gz-card" style={{ marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 12 }}>PAYMENT METHOD</div>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8 }}>
            <PayPill icon={I.cash}  label="Cash"    sub="At venue"      active={pay === 'cash'}    onClick={() => setPay('cash')} />
            <PayPill icon={I.upi}   label="UPI"     sub="Any app"       active={pay === 'upi'}     onClick={() => setPay('upi')} />
            <PayPill icon={I.card}  label="Card"    sub="Visa · Master" active={pay === 'card'}    onClick={() => setPay('card')} />
            <PayPill icon={I.coin}  label="Credits" sub="Balance only"  active={pay === 'credits'} onClick={() => setPay('credits')} />
          </div>
        </div>
      </Scroll>

      {/* sticky bottom CTA */}
      <div style={{ padding: '12px 16px 22px', background: 'var(--gz-bg)', flexShrink: 0,
        boxShadow: '0 -8px 16px -8px rgba(0,0,0,0.04)' }}>
        <button className="gz-btn" onClick={() => { setConfirmed(true); setTimeout(() => setConfirmed(false), 1800); }}
          style={{
            background: confirmed ? 'var(--gz-ok)' : 'var(--gz-btn)',
            transition: 'background .25s',
          }}>
          {confirmed ? (
            <>
              <svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 18, height: 18, color: '#fff' }}><path d="M5 12l5 5L20 7"/></svg>
              Booking confirmed
            </>
          ) : (
            <>Confirm booking · ₹{total.toFixed(0)}</>
          )}
        </button>
        <div className="gz-small" style={{ textAlign: 'center', marginTop: 8 }}>
          {pay === 'cash' ? 'Payment after session at counter' : 'Pay now to secure slot'}
        </div>
      </div>
    </Phone>
  );
}

function CampaignCard({ title, subtitle, tag, selected, disabled, onClick }) {
  return (
    <button onClick={disabled ? undefined : onClick}
      style={{
        flex: '0 0 200px',
        textAlign: 'left',
        padding: '14px',
        background: selected ? 'var(--gz-card-tint)' : 'var(--gz-pill-bg)',
        border: 0,
        outline: selected ? '2px solid var(--gz-fg)' : 'none',
        borderRadius: 14,
        opacity: disabled ? 0.55 : 1,
        cursor: disabled ? 'not-allowed' : 'pointer',
        display: 'flex', flexDirection: 'column', gap: 6,
      }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <span className="gz-body" style={{ fontWeight: 700 }}>{title}</span>
        {tag}
      </div>
      <span className="gz-small">{subtitle}</span>
    </button>
  );
}

function PayPill({ icon, label, sub, active, onClick }) {
  return (
    <button onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 10, padding: '12px 12px',
      background: active ? 'var(--gz-fg)' : 'var(--gz-pill-bg)',
      color: active ? '#fff' : 'var(--gz-fg)',
      border: 0, borderRadius: 14, textAlign: 'left',
    }}>
      {React.cloneElement(icon, { style: { width: 20, height: 20 } })}
      <span style={{ display: 'flex', flexDirection: 'column' }}>
        <span style={{ fontSize: 14, fontWeight: 600 }}>{label}</span>
        <span style={{ fontSize: 11, fontWeight: 500, opacity: active ? 0.65 : 0.5 }}>{sub}</span>
      </span>
    </button>
  );
}

Object.assign(window, { BookingSummaryScreen });
