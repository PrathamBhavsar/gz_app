// Screen 27 — Campaigns List
// All available campaigns at a store. Discovery + redemption entry point.

function CampaignsListScreen() {
  const [activeTab, setActiveTab] = useState('all');
  const [campDetail, setCampDetail] = useState(null);

  const allCampaigns = [
    {
      id: 1, type: 'Discount', color: '#8A5A12',
      title: 'Happy Hour',
      benefit: 'Save 30% on every booking Mon–Fri 10AM–2PM',
      eligibility: [{ ok: true, text: 'All members' }, { ok: false, text: 'Excludes VR' }],
      validity: 'Ends 30 Apr 2025',
      usage: '847 / unlimited',
      eligible: true,
    },
    {
      id: 2, type: 'Bonus Credits', color: '#2A4A8A',
      title: 'Double Credits Weekend',
      benefit: 'Earn 2× credits on all sessions this weekend',
      progress: { current: 847, max: 1000 },
      validity: 'This weekend only · Ends Sun 11:59 PM',
      badges: ['Limited', 'Eligible ✓'],
      eligible: true,
    },
    {
      id: 3, type: 'First Visit', color: '#5A3A82',
      title: 'First Visit Bonus',
      benefit: '200 bonus credits on your first booking at any new store',
      eligibility: [{ ok: true, text: 'New stores only' }, { ok: false, text: 'Already used at Koramangala' }],
      eligible: false,
      status: 'Not eligible at this store',
    },
    {
      id: 4, type: 'Bonus Credits', color: '#2A4A8A',
      title: 'Refer a Friend',
      benefit: 'Get 500 credits for every friend you refer',
      referrals: 'You\'ve referred 2 friends · 1000 credits earned',
      badges: ['New'],
      eligible: true,
    },
    {
      id: 5, type: 'Discount', color: '#8A5A12',
      title: 'Peak Hour Saver',
      benefit: 'Book 3+ hours and get 20% off the 3rd hour',
      eligibility: [{ ok: true, text: 'All members' }, { ok: true, text: 'All systems' }],
      eligible: true,
    },
  ];

  const filterTabs = [
    { id: 'all', label: 'All' },
    { id: 'discount', label: 'Discounts' },
    { id: 'bonus', label: 'Bonus Credits' },
    { id: 'happy', label: 'Happy Hour' },
    { id: 'first', label: 'First Visit' },
  ];

  let filteredCampaigns = allCampaigns;
  if (activeTab === 'discount') {
    filteredCampaigns = allCampaigns.filter(c => c.type === 'Discount');
  } else if (activeTab === 'bonus') {
    filteredCampaigns = allCampaigns.filter(c => c.type === 'Bonus Credits');
  } else if (activeTab === 'happy') {
    filteredCampaigns = allCampaigns.filter(c => c.id === 1);
  } else if (activeTab === 'first') {
    filteredCampaigns = allCampaigns.filter(c => c.id === 3);
  }

  const getTypeColor = (type) => {
    switch(type) {
      case 'Discount': return 'var(--gz-warn-bg)';
      case 'Bonus Credits': return 'var(--gz-info-bg)';
      case 'First Visit': return 'var(--gz-purple-bg)';
      default: return 'var(--gz-pill-bg)';
    }
  };

  const getTypeTextColor = (type) => {
    switch(type) {
      case 'Discount': return 'var(--gz-warn)';
      case 'Bonus Credits': return 'var(--gz-info)';
      case 'First Visit': return 'var(--gz-purple)';
      default: return 'var(--gz-fg-2)';
    }
  };

  return (
    <Phone>
      <TopBar
        title="Campaigns"
        onBack={() => {}}
      />

      <Scroll pad={false}>
        {/* store context banner */}
        <div style={{
          padding: '12px 16px',
          background: 'var(--gz-card)',
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
          borderBottom: '1px solid var(--gz-rule)',
        }}>
          <div className="gz-body" style={{ fontWeight: 600 }}>GameZone Koramangala</div>
          <button style={{
            background: 'transparent', border: 0,
            fontSize: 13, fontWeight: 600,
            color: 'var(--gz-fg)',
            textDecoration: 'underline',
            padding: 0,
          }}>
            Change
          </button>
        </div>

        {/* filter tabs */}
        <div style={{
          display: 'flex', gap: 0,
          borderBottom: '1px solid var(--gz-rule)',
          background: 'var(--gz-card)',
          padding: '0 16px',
        }}>
          {filterTabs.map(tab => (
            <button key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              style={{
                flex: 1,
                padding: '12px 0',
                background: 'transparent',
                border: 0,
                borderBottom: activeTab === tab.id ? '2px solid var(--gz-fg)' : 'none',
                fontSize: 13, fontWeight: 600,
                color: activeTab === tab.id ? 'var(--gz-fg)' : 'var(--gz-fg-3)',
                cursor: 'pointer',
              }}>
              {tab.label}
            </button>
          ))}
        </div>

        {/* campaigns list */}
        <div style={{ padding: '12px 16px 24px' }}>
          {filteredCampaigns.map(camp => (
            <div key={camp.id}
              onClick={() => !camp.referrals && setCampDetail(camp)}
              style={{
                width: '100%',
                background: 'var(--gz-card)',
                border: 0,
                borderRadius: 18,
                padding: '16px',
                marginBottom: 12,
                textAlign: 'left',
                opacity: camp.eligible ? 1 : 0.6,
                cursor: !camp.referrals ? 'pointer' : 'default',
              }}>
              {/* header with title and badge */}
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 10 }}>
                <div>
                  <div className="gz-h3" style={{ marginBottom: 4 }}>{camp.title}</div>
                  <span className="gz-tag" style={{
                    background: getTypeColor(camp.type),
                    color: getTypeTextColor(camp.type),
                  }}>
                    {camp.type}
                  </span>
                </div>
                {camp.badges && camp.badges.map((badge, i) => (
                  <span key={i} className="gz-tag" style={{
                    background: badge === 'Limited' ? 'var(--gz-warn-bg)' : badge === 'New' ? 'var(--gz-purple-bg)' : 'var(--gz-ok-bg)',
                    color: badge === 'Limited' ? 'var(--gz-warn)' : badge === 'New' ? 'var(--gz-purple)' : 'var(--gz-ok)',
                    fontSize: 10,
                  }}>
                    {badge}
                  </span>
                ))}
                {camp.eligible && !camp.badges && (
                  <span className="gz-tag" style={{
                    background: 'var(--gz-ok-bg)',
                    color: 'var(--gz-ok)',
                    fontSize: 10,
                  }}>
                    Eligible ✓
                  </span>
                )}
              </div>

              {/* benefit text */}
              <div className="gz-body" style={{ marginBottom: 10, color: 'var(--gz-fg-2)' }}>
                {camp.benefit}
              </div>

              {/* eligibility checks */}
              {camp.eligibility && (
                <div style={{ marginBottom: 10 }}>
                  {camp.eligibility.map((e, i) => (
                    <div key={i} className="gz-small" style={{
                      color: e.ok ? 'var(--gz-ok)' : 'var(--gz-err)',
                      marginBottom: i === camp.eligibility.length - 1 ? 0 : 4,
                    }}>
                      {e.ok ? '✓' : '✗'} {e.text}
                    </div>
                  ))}
                </div>
              )}

              {/* progress bar */}
              {camp.progress && (
                <div style={{ marginBottom: 10 }}>
                  <div className="gz-progress" style={{ marginBottom: 6 }}>
                    <i style={{ width: `${(camp.progress.current / camp.progress.max) * 100}%`, background: 'var(--gz-info)' }} />
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <span className="gz-num" style={{ fontSize: 12 }}>{camp.progress.current}</span>
                    <span className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>
                      / {camp.progress.max} redeemed
                    </span>
                  </div>
                </div>
              )}

              {/* referral info */}
              {camp.referrals && (
                <div className="gz-small" style={{ marginBottom: 10, color: 'var(--gz-fg-2)' }}>
                  {camp.referrals}
                </div>
              )}

              {/* validity & status */}
              <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: camp.status ? 8 : 0 }}>
                {camp.validity}
              </div>
              {camp.status && (
                <div className="gz-small" style={{ color: 'var(--gz-err)' }}>
                  {camp.status}
                </div>
              )}

              {/* CTA */}
              {camp.referrals ? (
                <div onClick={e => e.stopPropagation()}>
                  <button onClick={() => {}}
                    style={{
                      marginTop: 10,
                      background: 'transparent',
                      border: 0,
                      fontSize: 13, fontWeight: 600,
                      color: 'var(--gz-fg)',
                      textDecoration: 'underline',
                      padding: 0,
                      cursor: 'pointer',
                    }}>
                    Share referral link →
                  </button>
                </div>
              ) : null}
            </div>
          ))}
        </div>
      </Scroll>

      <BottomNav active="wallet" />

      {/* campaign detail sheet */}
      {campDetail && (
        <div className="gz-sheet-overlay" onClick={() => setCampDetail(null)}>
          <div className="gz-sheet" onClick={e => e.stopPropagation()}>
            <div className="gz-sheet__grab" />
            <div className="gz-h1" style={{ marginBottom: 8 }}>{campDetail.title}</div>
            <div className="gz-body" style={{ marginBottom: 16, color: 'var(--gz-fg-2)' }}>
              {campDetail.benefit}
            </div>
            <div className="gz-meta" style={{ marginBottom: 10 }}>DETAILS</div>
            {campDetail.eligibility && (
              <div style={{ marginBottom: 14 }}>
                {campDetail.eligibility.map((e, i) => (
                  <div key={i} style={{ display: 'flex', gap: 10, padding: '6px 0', alignItems: 'flex-start' }}>
                    <span style={{
                      width: 16, height: 16, borderRadius: 999,
                      background: e.ok ? 'var(--gz-ok-bg)' : 'var(--gz-err-bg)',
                      color: e.ok ? 'var(--gz-ok)' : 'var(--gz-err)',
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                      fontSize: 11, fontWeight: 600, flexShrink: 0,
                    }}>
                      {e.ok ? '✓' : '✗'}
                    </span>
                    <span className="gz-body" style={{ fontSize: 13 }}>{e.text}</span>
                  </div>
                ))}
              </div>
            )}
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>
              {campDetail.validity}
            </div>
          </div>
        </div>
      )}
    </Phone>
  );
}

Object.assign(window, { CampaignsListScreen });
