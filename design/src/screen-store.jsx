// Screen 5 — Store Detail
// Player tapped a store; full profile before booking.

function StoreDetailScreen() {
  const [slide, setSlide] = useState(0);
  const [systems, setSystems] = useState({
    s1: true, s2: false, s3: true, s4: true, s5: false,
  });
  const [bookRipple, setBookRipple] = useState(false);

  // Each "hero image" is a generated subtle stripe placeholder — never SVG drawings.
  const heroes = [
    { tag: 'STOREFRONT',   hue: 215 },
    { tag: 'PC LOUNGE',    hue: 145 },
    { tag: 'CONSOLE BAY',  hue: 25  },
  ];

  return (
    <Phone>
      {/* hero carousel — replaces the usual top bar */}
      <div style={{ position: 'relative', flexShrink: 0, margin: '6px 16px 0', borderRadius: 22, overflow: 'hidden', height: 200 }}>
        <HeroPlaceholder tag={heroes[slide].tag} hue={heroes[slide].hue} />

        {/* back button overlay */}
        <button onClick={() => {}} style={{
          position: 'absolute', top: 12, left: 12,
          width: 36, height: 36, border: 0, borderRadius: 999,
          background: 'rgba(255,255,255,0.85)', backdropFilter: 'blur(8px)',
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          color: 'var(--gz-fg)',
        }}>{I.back}</button>

        {/* star button overlay */}
        <button style={{
          position: 'absolute', top: 12, right: 12,
          width: 36, height: 36, border: 0, borderRadius: 999,
          background: 'rgba(255,255,255,0.85)', backdropFilter: 'blur(8px)',
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          color: 'var(--gz-fg)',
        }}>{I.star}</button>

        {/* carousel arrows */}
        <button onClick={() => setSlide((s) => (s - 1 + heroes.length) % heroes.length)} style={{
          position: 'absolute', top: '50%', left: 8, transform: 'translateY(-50%)',
          width: 30, height: 30, border: 0, borderRadius: 999, padding: 0,
          background: 'rgba(255,255,255,0.7)', color: 'var(--gz-fg)',
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        }}><svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 16, height: 16 }}><path d="M15 5l-7 7 7 7"/></svg></button>
        <button onClick={() => setSlide((s) => (s + 1) % heroes.length)} style={{
          position: 'absolute', top: '50%', right: 8, transform: 'translateY(-50%)',
          width: 30, height: 30, border: 0, borderRadius: 999, padding: 0,
          background: 'rgba(255,255,255,0.7)', color: 'var(--gz-fg)',
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        }}><svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 16, height: 16 }}><path d="M9 5l7 7-7 7"/></svg></button>

        {/* dots */}
        <div style={{
          position: 'absolute', bottom: 12, left: '50%', transform: 'translateX(-50%)',
          display: 'inline-flex', gap: 6, padding: '5px 8px',
          background: 'rgba(10,10,10,0.45)', borderRadius: 999,
        }}>
          {heroes.map((_, i) => (
            <span key={i} style={{
              width: i === slide ? 16 : 5, height: 5, borderRadius: 999,
              background: i === slide ? '#fff' : 'rgba(255,255,255,0.6)',
              transition: 'width .2s',
            }} />
          ))}
        </div>
      </div>

      <Scroll>
        {/* status block */}
        <div style={{ padding: '14px 4px 14px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
            <Tag kind="ok">Open now</Tag>
            <span className="gz-small">·</span>
            <span className="gz-body" style={{ fontWeight: 600 }}>
              <span style={{ marginRight: 4 }}>★</span>
              <span className="gz-num">4.7</span>
              <span className="gz-small" style={{ marginLeft: 4 }}>(412)</span>
            </span>
          </div>
          <h2 className="gz-title">GameZone Koramangala</h2>
          <div className="gz-small" style={{ marginTop: 6, display: 'inline-flex', alignItems: 'center', gap: 6 }}>
            {React.cloneElement(I.pin, { style: { width: 13, height: 13 } })}
            5th Block, 80ft Road · <span className="gz-num" style={{ fontWeight: 600 }}>1.2 km</span> away
          </div>
        </div>

        {/* quick info row */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, marginBottom: 16 }}>
          <InfoTile icon={I.clock} k="HOURS" v="9 – 23" />
          <InfoTile icon={I.phone} k="CALL"  v="Tap" actionable />
          <InfoTile icon={I.nav}   k="DIRECTIONS" v="Go" actionable />
        </div>

        {/* systems chips */}
        <div className="gz-meta" style={{ padding: '0 4px 10px' }}>STATIONS</div>
        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginBottom: 18 }}>
          {[
            { l: 'PC Gaming', c: 12 },
            { l: 'PS5',       c: 4  },
            { l: 'VR',        c: 2  },
            { l: 'Xbox',      c: 3  },
          ].map((s) => (
            <span key={s.l} className="gz-chip">
              {s.l}<span className="gz-chip__k" style={{ color: 'var(--gz-fg-3)', marginLeft: 4 }}>· {s.c}</span>
            </span>
          ))}
        </div>

        {/* campaigns */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 4px 10px' }}>
          <div className="gz-h2">Active campaigns</div>
          <span className="gz-small">2</span>
        </div>
        <div className="gz-hscroll" style={{ marginBottom: 18 }}>
          <MiniCamp title="Happy Hour"     sub="30% off · Mon–Fri 10–2"  tag={<Tag kind="ok">Eligible</Tag>} />
          <MiniCamp title="Double Credits" sub="Earn 2× this weekend"     tag={<Tag kind="warn">Limited</Tag>} />
        </div>

        {/* available now */}
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '0 4px 10px' }}>
          <div className="gz-h2">Available now</div>
          <span className="gz-small"><span className="gz-num">3</span> of 21 ready</span>
        </div>
        <div className="gz-hscroll" style={{ marginBottom: 14 }}>
          <SystemCard id="s1" icon={I.pc}   name="RTX 4090"   type="PC · Seat 3"    rate={80}
            available={systems.s1} onToggle={() => setSystems({ ...systems, s1: !systems.s1 })} />
          <SystemCard id="s2" icon={I.ps}   name="PS5 Slim"   type="Console · S1"  rate={60}
            available={systems.s2} onToggle={() => setSystems({ ...systems, s2: !systems.s2 })} />
          <SystemCard id="s3" icon={I.vr}   name="Valve Index" type="VR · Pod B"    rate={120}
            available={systems.s3} onToggle={() => setSystems({ ...systems, s3: !systems.s3 })} />
          <SystemCard id="s4" icon={I.xbox} name="Xbox Series X" type="Console · S4" rate={60}
            available={systems.s4} onToggle={() => setSystems({ ...systems, s4: !systems.s4 })} />
          <SystemCard id="s5" icon={I.pc}   name="RTX 3080"   type="PC · Seat 9"   rate={70}
            available={systems.s5} onToggle={() => setSystems({ ...systems, s5: !systems.s5 })} />
        </div>
      </Scroll>

      {/* sticky CTAs */}
      <div style={{ padding: '12px 16px 22px', background: 'var(--gz-bg)', flexShrink: 0,
        boxShadow: '0 -8px 16px -8px rgba(0,0,0,0.04)' }}>
        <button className="gz-btn" onClick={() => { setBookRipple(true); setTimeout(() => setBookRipple(false), 700); }}
          style={{
            background: bookRipple ? 'var(--gz-ok)' : 'var(--gz-fg)',
            transition: 'background 0.25s',
            position: 'relative', overflow: 'hidden',
          }}>
          {bookRipple ? (
            <>{React.cloneElement(I.check, { style: { width: 18, height: 18, color: '#fff' } })} Slot opened</>
          ) : 'Book a slot'}
        </button>
        <button className="gz-btn gz-btn--ghost" style={{ marginTop: 8, height: 44 }}>
          View all slots
        </button>
      </div>
    </Phone>
  );
}

function HeroPlaceholder({ tag, hue }) {
  // never hand-draw SVGs — subtly-striped diagonal placeholder + monospace label
  const bg = `oklch(0.92 0.04 ${hue})`;
  const stripe = `oklch(0.88 0.05 ${hue})`;
  return (
    <div style={{
      width: '100%', height: '100%',
      background: `repeating-linear-gradient(135deg, ${bg} 0 12px, ${stripe} 12px 24px)`,
      position: 'relative',
    }}>
      <div style={{
        position: 'absolute', bottom: 12, left: 14,
        padding: '3px 8px', borderRadius: 4,
        background: 'rgba(255,255,255,0.85)',
        fontFamily: 'var(--gz-mono)', fontSize: 10, fontWeight: 600,
        letterSpacing: '0.08em', color: 'var(--gz-fg-2)',
      }}>{tag}</div>
    </div>
  );
}

function InfoTile({ icon, k, v, actionable }) {
  return (
    <button style={{
      padding: '12px 12px',
      background: 'var(--gz-card)',
      border: 0, borderRadius: 14, textAlign: 'left',
      display: 'flex', flexDirection: 'column', gap: 4, cursor: actionable ? 'pointer' : 'default',
    }}>
      <span style={{ color: 'var(--gz-fg-2)' }}>
        {React.cloneElement(icon, { style: { width: 16, height: 16 } })}
      </span>
      <span className="gz-meta" style={{ marginTop: 6 }}>{k}</span>
      <span className="gz-body" style={{ fontWeight: 600 }}>{v}</span>
    </button>
  );
}

function MiniCamp({ title, sub, tag }) {
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

function SystemCard({ icon, name, type, rate, available, onToggle }) {
  return (
    <button onClick={onToggle}
      style={{
        flex: '0 0 170px',
        padding: 14, textAlign: 'left',
        background: available ? 'var(--gz-card-tint)' : 'var(--gz-card)',
        border: 0, borderRadius: 16,
        display: 'flex', flexDirection: 'column', gap: 10,
      }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div className="gz-tile gz-tile--sq" style={{ width: 36, height: 36, background: available ? 'rgba(10,10,10,0.06)' : 'var(--gz-pill-bg)' }}>
          {React.cloneElement(icon, { style: { width: 18, height: 18 } })}
        </div>
        {available
          ? <Tag kind="ok">Available</Tag>
          : <Tag kind="mute">In use</Tag>}
      </div>
      <div>
        <div className="gz-body" style={{ fontWeight: 700 }}>{name}</div>
        <div className="gz-small" style={{ marginTop: 2 }}>{type}</div>
      </div>
      <div className="gz-body gz-num" style={{ fontWeight: 700 }}>
        ₹{rate}<span className="gz-small" style={{ fontWeight: 500 }}> / hr</span>
      </div>
    </button>
  );
}

Object.assign(window, { StoreDetailScreen });
