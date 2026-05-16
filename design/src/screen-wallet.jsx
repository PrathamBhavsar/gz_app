// Screen 4 — Wallet Home
// Store-scoped credits, transactions, campaigns. Store selector overlay.

function WalletScreen() {
  const stores = [
    { id: 'kor', name: 'GameZone Koramangala', credits: 850 },
    { id: 'mgr', name: 'GameZone MG Road',     credits: 220 },
    { id: 'hsr', name: 'GameZone HSR',         credits:  80 },
  ];
  const [storeId, setStoreId] = useState('kor');
  const [showStores, setShowStores] = useState(false);
  const [redeemOpen, setRedeemOpen] = useState(false);
  const [redeemAmt, setRedeemAmt] = useState(100);
  const [seeAllTx, setSeeAllTx] = useState(false);
  const [earnInfo, setEarnInfo] = useState(false);
  const [campDetail, setCampDetail] = useState(null);

  const store = stores.find(s => s.id === storeId);
  const credits = store.credits;
  const rupees = (credits / 10).toFixed(2);

  const allTx = [
    { icon: I.star, label: 'Session completed',   sub: '2 hours ago',  amt: 80,  sign: '+', kind: 'ok' },
    { icon: I.up,   label: 'Credits redeemed',    sub: 'Yesterday',    amt: 300, sign: '−', kind: 'err' },
    { icon: I.gift, label: 'Welcome bonus',       sub: '3 days ago',   amt: 200, sign: '+', kind: 'ok' },
    { icon: I.star, label: 'Session completed',   sub: '5 days ago',   amt: 60,  sign: '+', kind: 'ok' },
    { icon: I.gift, label: 'Referral bonus',      sub: '1 week ago',   amt: 500, sign: '+', kind: 'ok' },
    { icon: I.up,   label: 'Credits redeemed',    sub: '2 weeks ago',  amt: 200, sign: '−', kind: 'err' },
  ];
  const txList = seeAllTx ? allTx : allTx.slice(0, 3);

  return (
    <Phone>
      <div style={{ padding: '4px 16px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}>
        <h1 className="gz-title">Wallet</h1>
        <IconBtn>{I.bell}</IconBtn>
      </div>

      <Scroll>
        {/* store selector */}
        <button onClick={() => setShowStores(true)}
          style={{
            display: 'inline-flex', alignItems: 'center', gap: 8,
            padding: '8px 14px',
            background: 'var(--gz-pill-bg)',
            border: 0, borderRadius: 999,
            margin: '4px 0 16px',
          }}>
          <span className="gz-body" style={{ fontWeight: 600 }}>{store.name}</span>
          {React.cloneElement(I.chevDn, { style: { width: 16, height: 16, color: 'var(--gz-fg-3)' } })}
        </button>

        {/* hero balance — mint tinted */}
        <div className="gz-card gz-card--tint" style={{ padding: 22, marginBottom: 12 }}>
          <div className="gz-meta" style={{ marginBottom: 14, color: 'var(--gz-fg-2)' }}>YOUR CREDITS</div>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginBottom: 6 }}>
            <span className="gz-hero">{credits}</span>
            <span className="gz-body" style={{ fontWeight: 500, color: 'var(--gz-fg-2)' }}>credits</span>
          </div>
          <div className="gz-body" style={{ color: 'var(--gz-fg-2)' }}>
            = <span className="gz-num">₹{rupees}</span> in-store value
          </div>
          <div style={{ height: 1, background: 'rgba(10,10,10,0.08)', margin: '16px 0' }} />
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>
              Valid at {store.name} only
            </span>
            <button onClick={() => setEarnInfo(true)}
              style={{ background: 'transparent', border: 0, padding: 0,
                fontSize: 12, fontWeight: 600, textDecoration: 'underline', color: 'var(--gz-fg)' }}>
              How do I earn more?
            </button>
          </div>
        </div>

        {/* quick actions */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginBottom: 18 }}>
          <QuickAction icon={I.coin}   label="Redeem"   onClick={() => setRedeemOpen(true)} />
          <QuickAction icon={I.list}   label="History" />
          <QuickAction icon={I.gift}   label="Campaigns" />
        </div>

        {/* transactions */}
        <div className="gz-card" style={{ padding: 0, marginBottom: 18 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '16px 20px 8px' }}>
            <div className="gz-h2">Recent</div>
            <button onClick={() => setSeeAllTx(s => !s)}
              style={{ background: 'transparent', border: 0, padding: 0, color: 'var(--gz-fg-3)', fontSize: 12, fontWeight: 600 }}>
              {seeAllTx ? 'Show less' : 'See all →'}
            </button>
          </div>
          {txList.map((tx, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 12, padding: '12px 20px',
              borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)' }}>
              <Avatar 
                size="md" 
                bg={tx.kind === 'ok' ? 'var(--gz-ok-bg)' : 'var(--gz-err-bg)'}
                iconColor={tx.kind === 'ok' ? 'var(--gz-ok)' : 'var(--gz-err)'}
                icon={tx.icon}
              />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div className="gz-body" style={{ fontWeight: 600 }}>{tx.label}</div>
                <div className="gz-small" style={{ marginTop: 1 }}>{tx.sub}</div>
              </div>
              <div className="gz-body gz-num" style={{
                fontWeight: 700,
                color: tx.kind === 'ok' ? 'var(--gz-ok)' : 'var(--gz-err)',
              }}>
                {tx.sign}{tx.amt}
              </div>
            </div>
          ))}
        </div>

        {/* campaigns */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 4px 10px' }}>
          <div className="gz-h2">Active campaigns</div>
          <span className="gz-small">3</span>
        </div>
        <div className="gz-hscroll" style={{ marginBottom: 6 }}>
          <CampCard
            title="Happy Hour"
            sub="30% off · Mon–Fri 10am–2pm"
            tag={<Tag kind="ok">Eligible</Tag>}
            footer={<span>Ends 30 Apr</span>}
            onClick={() => setCampDetail({ title: 'Happy Hour', body: 'Get 30% off all sessions during weekday off-peak hours. Auto-applied at checkout.', terms: ['Valid Mon–Fri 10am–2pm', 'Excludes VR rigs', 'Stackable with credits'] })} />
          <CampCard
            title="Double credits"
            sub="Earn 2× credits this weekend"
            tag={<Tag kind="warn">Limited</Tag>}
            footer={
              <div style={{ width: '100%' }}>
                <div className="gz-progress" style={{ height: 4, marginBottom: 5 }}>
                  <i style={{ width: '84.7%', background: 'var(--gz-warn)' }} />
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                  <span className="gz-num">847</span><span className="gz-num gz-small" style={{ color: 'var(--gz-fg-3)' }}>/ 1000 redeemed</span>
                </div>
              </div>
            }
            onClick={() => setCampDetail({ title: 'Double Credits Weekend', body: 'Every session this Saturday and Sunday earns double the credits.', terms: ['Sat–Sun only', 'First 1000 customers', 'No max cap'] })} />
          <CampCard
            title="Refer a friend"
            sub="Get 500 credits per referral"
            tag={<Tag kind="purple">New</Tag>}
            footer={<span style={{ textDecoration: 'underline' }}>Share invite link →</span>}
            onClick={() => setCampDetail({ title: 'Refer a Friend', body: 'Invite friends to GameZone. They get ₹100 off their first booking; you get 500 credits when they complete it.', terms: ['Unlimited referrals', 'Credits valid 90 days', 'New users only'] })} />
        </div>
      </Scroll>

      <BottomNav active="wallet" />

      {/* store selector overlay */}
      {showStores && (
        <div className="gz-sheet-overlay" onClick={() => setShowStores(false)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 4 }}>Switch store</div>
            <div className="gz-body-r" style={{ marginBottom: 16 }}>Credits are scoped per store</div>
            {stores.map(s => (
              <button key={s.id}
                onClick={() => { setStoreId(s.id); setShowStores(false); }}
                style={{
                  width: '100%', padding: 14,
                  background: s.id === storeId ? 'var(--gz-card-tint)' : 'var(--gz-pill-bg)',
                  border: 0, borderRadius: 14, marginBottom: 8,
                  display: 'flex', alignItems: 'center', justifyContent: 'space-between', textAlign: 'left',
                }}>
                <div>
                  <div className="gz-body" style={{ fontWeight: 600 }}>{s.name}</div>
                  <div className="gz-small" style={{ marginTop: 2 }}>
                    <span className="gz-num">{s.credits}</span> credits available
                  </div>
                </div>
                {s.id === storeId && (
                  <svg viewBox="0 0 24 24" className="gz-ic" style={{ color: 'var(--gz-fg)' }}><path d="M5 12l5 5L20 7"/></svg>
                )}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* redeem sheet */}
      {redeemOpen && (
        <div className="gz-sheet-overlay" onClick={() => setRedeemOpen(false)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 4 }}>Redeem credits</div>
            <div className="gz-body-r" style={{ marginBottom: 18 }}>
              <span className="gz-num">{credits}</span> available · 10 credits = ₹1
            </div>

            <div className="gz-card gz-card--inset" style={{ marginBottom: 16, textAlign: 'center' }}>
              <div className="gz-meta" style={{ marginBottom: 8 }}>REDEEM</div>
              <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'center', gap: 12 }}>
                <span className="gz-hero-md">{redeemAmt}</span>
                <span className="gz-body-r">= ₹{(redeemAmt / 10).toFixed(0)}</span>
              </div>
              <input className="gz-slider" type="range" min="0" max={credits} step="10"
                value={redeemAmt} onChange={e => setRedeemAmt(+e.target.value)}
                style={{ marginTop: 16 }} />
              <div style={{ display: 'flex', gap: 6, marginTop: 14, justifyContent: 'center' }}>
                {[100, 250, 500, credits].map(v => (
                  <button key={v} onClick={() => setRedeemAmt(Math.min(credits, v))} style={{
                    padding: '6px 12px',
                    background: redeemAmt === v ? 'var(--gz-fg)' : '#fff',
                    color: redeemAmt === v ? '#fff' : 'var(--gz-fg)',
                    border: 0, borderRadius: 999, fontSize: 12, fontWeight: 600,
                    fontFamily: 'var(--gz-mono)',
                  }}>{v === credits ? 'Max' : v}</button>
                ))}
              </div>
            </div>

            <button className="gz-btn">Redeem {redeemAmt} credits</button>
          </div>
        </div>
      )}

      {/* earn info popover */}
      {earnInfo && (
        <div className="gz-sheet-overlay" onClick={() => setEarnInfo(false)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()} style={{ paddingBottom: 24 }}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 14 }}>How to earn credits</div>
            {[
              { k: '40 / hr',  v: 'Completing booked sessions' },
              { k: '200',      v: 'First-time booking at any store' },
              { k: '500',      v: 'When a referred friend books' },
              { k: '2×',       v: 'During Double Credits weekends' },
            ].map((r, i) => (
              <div key={i} style={{ display: 'flex', gap: 14, padding: '12px 0',
                borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)' }}>
                <span className="gz-chip" style={{ flexShrink: 0, minWidth: 72, justifyContent: 'center' }}>{r.k}</span>
                <span className="gz-body" style={{ alignSelf: 'center' }}>{r.v}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* campaign detail */}
      {campDetail && (
        <div className="gz-sheet-overlay" onClick={() => setCampDetail(null)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()} style={{ paddingBottom: 24 }}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 8 }}>{campDetail.title}</div>
            <div className="gz-body-r" style={{ marginBottom: 18 }}>{campDetail.body}</div>
            <div className="gz-meta" style={{ marginBottom: 10 }}>TERMS</div>
            {campDetail.terms.map((t, i) => (
              <div key={i} style={{ display: 'flex', gap: 10, padding: '8px 0', alignItems: 'flex-start' }}>
                <span style={{ width: 4, height: 4, borderRadius: 999, background: 'var(--gz-fg-3)', marginTop: 8, flexShrink: 0 }} />
                <span className="gz-body" style={{ fontSize: 13 }}>{t}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </Phone>
  );
}

function QuickAction({ icon, label, onClick }) {
  return (
    <button onClick={onClick} style={{
      padding: '14px 8px',
      background: 'var(--gz-card)',
      border: 0, borderRadius: 16,
      display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
    }}>
      <span style={{ color: 'var(--gz-fg)' }}>
        {React.cloneElement(icon, { style: { width: 20, height: 20 } })}
      </span>
      <span className="gz-small" style={{ color: 'var(--gz-fg)', fontWeight: 600, fontSize: 12 }}>{label}</span>
    </button>
  );
}

function CampCard({ title, sub, tag, footer, onClick }) {
  return (
    <button onClick={onClick} style={{
      flex: '0 0 220px',
      textAlign: 'left',
      padding: 16,
      background: 'var(--gz-card)',
      border: 0, borderRadius: 18,
      display: 'flex', flexDirection: 'column', gap: 8, minHeight: 130,
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <span className="gz-h3">{title}</span>
        {tag}
      </div>
      <span className="gz-small" style={{ flex: 1 }}>{sub}</span>
      <div className="gz-small" style={{ color: 'var(--gz-fg-2)', fontWeight: 500, marginTop: 4 }}>
        {footer}
      </div>
    </button>
  );
}

Object.assign(window, { WalletScreen });
