// Screen 12 — Home Feed
// First screen after login. Discovery + active session + upcoming + campaigns.

function HomeFeedScreen() {
  const [searchFocus, setSearchFocus] = useState(false);
  const [navigating, setNavigating] = useState(null);
  const [unread, setUnread] = useState(3);

  const [elapsed, setElapsed] = useState(23 * 60 + 56);
  useEffect(() => {
    const t = setInterval(() => setElapsed(e => e + 1), 1000);
    return () => clearInterval(t);
  }, []);
  const remain = 2 * 3600 - elapsed;
  const remStr = `${Math.floor(remain / 3600)}h ${String(Math.floor((remain % 3600) / 60)).padStart(2, '0')}m`;

  const goToStore = (name) => {
    setNavigating(name);
    setTimeout(() => setNavigating(null), 1100);
  };

  return (
    <Phone>
      {/* header */}
      <div style={{ padding: '4px 16px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 32, height: 32, borderRadius: 8,
            background: 'var(--gz-fg)', color: 'var(--gz-card-tint-strong)',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: 'var(--gz-mono)', fontSize: 16, fontWeight: 700,
            letterSpacing: '-0.04em',
          }}>GZ</div>
          <div>
            <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: -2 }}>
              Hey,
            </div>
            <div className="gz-h3" style={{ lineHeight: 1.1 }}>Pratham</div>
          </div>
        </div>
        <div style={{ position: 'relative' }}>
          <IconBtn onClick={() => setUnread(0)}>{I.bell}</IconBtn>
          {unread > 0 && (
            <span style={{
              position: 'absolute', top: 4, right: 4,
              minWidth: 16, height: 16, padding: '0 4px',
              borderRadius: 999, background: 'var(--gz-err)', color: '#fff',
              fontSize: 9.5, fontWeight: 700, fontFamily: 'var(--gz-mono)',
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
              boxShadow: '0 0 0 2px var(--gz-bg)',
            }}>{unread}</span>
          )}
        </div>
      </div>

      {/* search */}
      <div style={{ padding: '12px 16px 0', flexShrink: 0 }}>
        <button onClick={() => setSearchFocus(f => !f)}
          style={{
            width: '100%', padding: '14px 16px',
            background: 'var(--gz-card)', border: 0, borderRadius: 16,
            display: 'flex', alignItems: 'center', gap: 10, textAlign: 'left',
            boxShadow: searchFocus ? 'inset 0 0 0 1.5px var(--gz-fg)' : 'none',
            transition: 'box-shadow .15s',
          }}>
          <span style={{ color: 'var(--gz-fg-3)' }}>
            {React.cloneElement(I.search, { style: { width: 18, height: 18 } })}
          </span>
          <span className="gz-body" style={{ color: 'var(--gz-fg-3)', fontWeight: 500 }}>
            {searchFocus ? '|' : 'Search gaming stores...'}
          </span>
        </button>
      </div>

      <Scroll>
        {/* active session banner */}
        <div className="gz-card gz-card--tint"
          style={{ padding: 14, marginTop: 12, marginBottom: 18,
            display: 'flex', alignItems: 'center', gap: 12, cursor: 'pointer' }}>
          <div style={{
            width: 38, height: 38, borderRadius: 999,
            background: 'var(--gz-fg)',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            flexShrink: 0,
          }}>
            <span className="gz-dot-pulse" style={{ background: 'var(--gz-card-tint-strong)' }} />
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}>
              <span className="gz-meta" style={{ color: 'var(--gz-ok)' }}>LIVE</span>
              <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>at GameZone Koramangala</span>
            </div>
            <div className="gz-body" style={{ fontWeight: 700, marginTop: 3 }}>
              <span className="gz-num">{remStr}</span> remaining
            </div>
          </div>
          <span style={{ color: 'var(--gz-fg)' }}>{I.chev}</span>
        </div>

        {/* nearby stores */}
        <SectionHead title="Nearby stores" sub="3 within 10km" />
        <div className="gz-hscroll" style={{ marginBottom: 22 }}>
          <StoreCardLg name="GameZone Koramangala" dist="1.2km" rating="4.7"
            count={18} open={true} hue={145} tag="STOREFRONT"
            onTap={() => goToStore('GameZone Koramangala')} />
          <StoreCardLg name="GameZone MG Road"     dist="2.8km" rating="4.5"
            count={12} open={true} hue={215} tag="PC LOUNGE"
            onTap={() => goToStore('GameZone MG Road')} />
          <StoreCardLg name="GameZone Whitefield"  dist="6.1km" rating="4.3"
            count={8} open={false} openAt="10 AM" hue={25} tag="ESPORTS BAR"
            onTap={() => goToStore('GameZone Whitefield')} />
        </div>

        {/* upcoming booking */}
        <SectionHead title="Your next booking" sub="Tomorrow" />
        <div className="gz-card" style={{ marginBottom: 22 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 12 }}>
            <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
              <div className="gz-tile gz-tile--sq" style={{ width: 40, height: 40 }}>
                {React.cloneElement(I.pc, { style: { width: 18, height: 18 } })}
              </div>
              <div>
                <div className="gz-body" style={{ fontWeight: 700 }}>RTX 4090 — Seat 3</div>
                <div className="gz-small" style={{ marginTop: 2 }}>GameZone Koramangala</div>
              </div>
            </div>
            <Tag kind="ok">Confirmed</Tag>
          </div>
          <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 12 }}>
            <span className="gz-chip"><span className="gz-chip__k">WHEN</span>Tomorrow · 4–6 PM</span>
            <span className="gz-chip"><span className="gz-chip__k">PAID</span>₹160</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <span className="gz-small">Starts in <span className="gz-num" style={{ color: 'var(--gz-fg)', fontWeight: 600 }}>18h 24m</span></span>
            <span style={{ fontSize: 12, fontWeight: 700, color: 'var(--gz-fg)' }}>View →</span>
          </div>
        </div>

        {/* campaigns */}
        <SectionHead title="Active campaigns" sub="Near you" />
        <div className="gz-hscroll" style={{ marginBottom: 22 }}>
          <MiniCamp2 title="Happy Hour"       sub="30% off · Mon–Fri 10–2"      tag={<Tag kind="ok">Eligible</Tag>} />
          <MiniCamp2 title="Double Credits"   sub="Earn 2× this weekend"        tag={<Tag kind="warn">Limited</Tag>} />
        </div>

        {/* new */}
        <SectionHead title="New in Bengaluru" sub="2 stores" />
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 8 }}>
          <NewStoreRow name="GameZone Whitefield" addr="ITPL Main Rd · 6.1km" count={8}
            hue={25}  tag="ESPORTS BAR" onTap={() => goToStore('GameZone Whitefield')} />
          <NewStoreRow name="GameZone Indiranagar" addr="100ft Rd · 4.2km" count={14}
            hue={300} tag="PC LOUNGE" onTap={() => goToStore('GameZone Indiranagar')} />
        </div>
      </Scroll>

      <BottomNav active="home" />

      {/* navigating overlay */}
      {navigating && (
        <div style={{
          position: 'absolute', inset: 0,
          background: 'rgba(10,10,10,0.5)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          zIndex: 80, animation: 'gz-fade 0.15s ease-out',
        }}>
          <div style={{
            background: 'var(--gz-card)', borderRadius: 18, padding: '18px 22px',
            display: 'flex', alignItems: 'center', gap: 12,
            animation: 'gz-slide-up 0.18s cubic-bezier(.2,.7,.3,1)',
            maxWidth: '80%',
          }}>
            <Spinner />
            <div>
              <div className="gz-meta" style={{ marginBottom: 2 }}>OPENING</div>
              <div className="gz-body" style={{ fontWeight: 700,
                whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                {navigating}
              </div>
            </div>
          </div>
        </div>
      )}
    </Phone>
  );
}

function SectionHead({ title, sub }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 4px 10px' }}>
      <div className="gz-h2">{title}</div>
      <span className="gz-small">{sub}</span>
    </div>
  );
}

function StoreCardLg({ name, dist, rating, count, open, openAt, hue, tag, onTap }) {
  const bg = `oklch(0.92 0.04 ${hue})`;
  const stripe = `oklch(0.88 0.05 ${hue})`;
  return (
    <button onClick={onTap}
      style={{
        flex: '0 0 240px',
        background: 'var(--gz-card)', border: 0, borderRadius: 18,
        padding: 0, overflow: 'hidden', textAlign: 'left',
        display: 'flex', flexDirection: 'column',
      }}>
      <div style={{
        height: 110,
        background: `repeating-linear-gradient(135deg, ${bg} 0 12px, ${stripe} 12px 24px)`,
        position: 'relative',
      }}>
        <div style={{
          position: 'absolute', bottom: 8, left: 10,
          padding: '3px 7px', borderRadius: 4,
          background: 'rgba(255,255,255,0.85)',
          fontFamily: 'var(--gz-mono)', fontSize: 9, fontWeight: 600,
          letterSpacing: '0.08em', color: 'var(--gz-fg-2)',
        }}>{tag}</div>
        <div style={{ position: 'absolute', top: 8, right: 8 }}>
          {open ? <Tag kind="ok">Open</Tag> : <Tag kind="mute">Opens {openAt}</Tag>}
        </div>
      </div>
      <div style={{ padding: 12, display: 'flex', flexDirection: 'column', gap: 6 }}>
        <div className="gz-body" style={{ fontWeight: 700,
          whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{name}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 11.5 }}>
          <span style={{ color: 'var(--gz-fg-2)', fontWeight: 600 }}>
            ★ <span className="gz-num">{rating}</span>
          </span>
          <span style={{ color: 'var(--gz-fg-3)' }}>·</span>
          <span className="gz-num" style={{ color: 'var(--gz-fg-2)', fontWeight: 600 }}>{dist}</span>
          <span style={{ color: 'var(--gz-fg-3)' }}>·</span>
          <span style={{ color: 'var(--gz-fg-3)' }}><span className="gz-num">{count}</span> systems</span>
        </div>
      </div>
    </button>
  );
}

function MiniCamp2({ title, sub, tag }) {
  return (
    <div style={{
      flex: '0 0 220px',
      padding: 14,
      background: 'var(--gz-card)', borderRadius: 16,
      display: 'flex', flexDirection: 'column', gap: 6,
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <span className="gz-h3">{title}</span>{tag}
      </div>
      <span className="gz-small">{sub}</span>
    </div>
  );
}

function NewStoreRow({ name, addr, count, hue, tag, onTap }) {
  const bg = `oklch(0.92 0.04 ${hue})`;
  const stripe = `oklch(0.88 0.05 ${hue})`;
  return (
    <button onClick={onTap}
      style={{
        width: '100%', padding: 12,
        background: 'var(--gz-card)', border: 0, borderRadius: 16,
        display: 'flex', gap: 12, alignItems: 'center', textAlign: 'left',
      }}>
      <div style={{
        width: 56, height: 56, borderRadius: 12, flexShrink: 0,
        background: `repeating-linear-gradient(135deg, ${bg} 0 8px, ${stripe} 8px 16px)`,
        position: 'relative',
      }}>
        <span style={{
          position: 'absolute', bottom: 3, left: 3,
          padding: '1px 4px', borderRadius: 3,
          background: 'rgba(255,255,255,0.85)',
          fontFamily: 'var(--gz-mono)', fontSize: 7, fontWeight: 600,
          letterSpacing: '0.06em', color: 'var(--gz-fg-2)',
        }}>{tag}</span>
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
          <span className="gz-body" style={{ fontWeight: 700,
            whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{name}</span>
          <Tag kind="purple">New</Tag>
        </div>
        <div className="gz-small">{addr} · <span className="gz-num" style={{ fontWeight: 600 }}>{count}</span> systems</div>
      </div>
      <span style={{ color: 'var(--gz-fg-3)' }}>{I.chev}</span>
    </button>
  );
}

Object.assign(window, { HomeFeedScreen });
