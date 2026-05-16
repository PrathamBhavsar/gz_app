// Screen 11 — Systems Browser → Availability Calendar (stepped flow)
// Two screens in one artboard. Tapping a system slides over to the slot picker.

const SYSTEMS = [
  { id: 's1', name: 'RTX 4090',     type: 'PC',  icon: 'pc',   specs: 'RTX 4090 · 240Hz',  rate: 80, state: 'free' },
  { id: 's2', name: 'PS5 Slim',     type: 'PS5', icon: 'ps',   specs: 'DualSense · 4K',     rate: 60, state: 'free' },
  { id: 's3', name: 'Valve Index',  type: 'VR',  icon: 'vr',   specs: 'Full body tracking', rate: 120, state: 'free' },
  { id: 's4', name: 'RTX 3080',     type: 'PC',  icon: 'pc',   specs: 'RTX 3080 · 144Hz',   rate: 70, state: 'busy', free: '6:00 PM' },
  { id: 's5', name: 'Xbox Series X', type: 'Xbox', icon: 'xbox', specs: '120Hz · Game Pass',  rate: 60, state: 'busy', free: '7:30 PM' },
  { id: 's6', name: 'Meta Quest 3', type: 'VR',  icon: 'vr',   specs: 'Standalone · 128GB', rate: 100, state: 'down' },
];

const SLOTS_TIMES = [
  '10:00 AM','10:30 AM','11:00 AM','11:30 AM',
  '12:00 PM','12:30 PM','1:00 PM','1:30 PM',
  '2:00 PM','2:30 PM','3:00 PM','3:30 PM',
  '4:00 PM','4:30 PM','5:00 PM','5:30 PM',
  '6:00 PM','6:30 PM','7:00 PM','7:30 PM',
  '8:00 PM','8:30 PM','9:00 PM','9:30 PM',
];
const SLOT_STATE = [
  // morning mostly booked
  'b','b','b','b','b','w','b','b',
  // afternoon mixed
  'a','a','b','w','a','a','b','a',
  // evening mostly free
  'a','a','a','a','a','b','a','a',
];

function SystemsBrowserScreen() {
  const [step, setStep] = useState(1);
  const [filter, setFilter] = useState('all');
  const [selectedSys, setSelectedSys] = useState(null);
  const [dayIdx, setDayIdx] = useState(1); // 0 = today, 1 = tomorrow
  const [slotIdx, setSlotIdx] = useState(12); // 4:00 PM
  const [duration, setDuration] = useState(2);

  const days = ['Wed 16', 'Thu 17', 'Fri 18', 'Sat 19', 'Sun 20', 'Mon 21', 'Tue 22'];
  const TYPES = ['all', 'PC', 'PS5', 'Xbox', 'VR', 'Other'];
  const filtered = SYSTEMS.filter(s => filter === 'all' || s.type === filter);

  const enterCalendar = (sys) => { setSelectedSys(sys); setStep(2); };
  const price = (selectedSys?.rate || 80) * duration;

  return (
    <Phone>
      <div style={{ position: 'relative', flex: 1, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
        {/* Step 1 */}
        <div style={{
          position: 'absolute', inset: 0,
          display: 'flex', flexDirection: 'column',
          transform: step === 1 ? 'translateX(0)' : 'translateX(-30%)',
          opacity: step === 1 ? 1 : 0,
          transition: 'transform .35s cubic-bezier(.2,.7,.3,1), opacity .25s',
          pointerEvents: step === 1 ? 'auto' : 'none',
        }}>
          <TopBar title="Pick a system" subtitle="GameZone Koramangala · Change"
            onBack={() => {}} />

          <Scroll pad>
            {/* filter tabs (horizontal scroll) */}
            <div style={{
              display: 'flex', gap: 6, overflowX: 'auto', overflowY: 'hidden',
              padding: '4px 0 14px', margin: '0 -4px',
              scrollbarWidth: 'none',
            }}>
              {TYPES.map(t => (
                <button key={t} onClick={() => setFilter(t)}
                  style={{
                    flex: '0 0 auto', padding: '8px 14px', border: 0, borderRadius: 999,
                    background: filter === t ? 'var(--gz-fg)' : 'var(--gz-pill-bg)',
                    color: filter === t ? '#fff' : 'var(--gz-fg-2)',
                    fontSize: 13, fontWeight: 600,
                  }}>{t === 'all' ? 'All' : t}</button>
              ))}
            </div>

            {/* grid */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
              {filtered.map(s => (
                <GridSystemCard key={s.id} sys={s} onTap={() => s.state !== 'down' && enterCalendar(s)} />
              ))}
            </div>
            <div style={{ height: 16 }} />
          </Scroll>

          <div style={{ padding: '12px 16px 22px', background: 'var(--gz-bg)', flexShrink: 0 }}>
            <button className="gz-btn" disabled style={{ opacity: 0.55 }}>
              Tap a system to check availability
            </button>
          </div>
        </div>

        {/* Step 2 */}
        <div style={{
          position: 'absolute', inset: 0,
          display: 'flex', flexDirection: 'column',
          transform: step === 2 ? 'translateX(0)' : 'translateX(100%)',
          transition: 'transform .35s cubic-bezier(.2,.7,.3,1)',
          background: 'var(--gz-bg)',
        }}>
          {selectedSys && (
            <>
              <TopBar
                title={selectedSys.name}
                subtitle={selectedSys.specs}
                onBack={() => setStep(1)}
                trailing={<span className="gz-num gz-h3" style={{ fontWeight: 700 }}>₹{selectedSys.rate}/hr</span>} />

              <Scroll pad>
                {/* date strip */}
                <div className="gz-meta" style={{ marginBottom: 10 }}>SELECT DAY</div>
                <div className="gz-hscroll" style={{ marginBottom: 18 }}>
                  {days.map((d, i) => {
                    const isPast = i < 0;
                    const sel = i === dayIdx;
                    return (
                      <button key={d} onClick={() => setDayIdx(i)} disabled={isPast}
                        style={{
                          flex: '0 0 64px', padding: '10px 4px',
                          background: sel ? 'var(--gz-fg)' : 'var(--gz-card)',
                          color: sel ? '#fff' : (isPast ? 'var(--gz-fg-4)' : 'var(--gz-fg)'),
                          border: 0, borderRadius: 14, textAlign: 'center',
                          opacity: isPast ? 0.5 : 1,
                          display: 'flex', flexDirection: 'column', gap: 2,
                        }}>
                        <span style={{ fontSize: 10, fontWeight: 600, letterSpacing: '0.06em', textTransform: 'uppercase', opacity: 0.7 }}>
                          {d.split(' ')[0]}
                        </span>
                        <span className="gz-num" style={{ fontSize: 18, fontWeight: 700, lineHeight: 1 }}>
                          {d.split(' ')[1]}
                        </span>
                      </button>
                    );
                  })}
                </div>

                {/* slot legend */}
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 10 }}>
                  <span className="gz-meta">TIME SLOTS · {days[dayIdx]}</span>
                  <span style={{ display: 'inline-flex', gap: 10 }}>
                    <Legend dot="var(--gz-ok)" l="Free" />
                    <Legend dot="var(--gz-warn)" l="Walk-in" />
                    <Legend dot="var(--gz-rule)" l="Booked" />
                  </span>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 6, marginBottom: 18 }}>
                  {SLOTS_TIMES.map((t, i) => {
                    const st = SLOT_STATE[i];
                    const isSel = i === slotIdx && st !== 'b';
                    const disabled = st === 'b';
                    return (
                      <button key={t} disabled={disabled}
                        onClick={() => !disabled && setSlotIdx(i)}
                        style={{
                          padding: '10px 8px',
                          background:
                            isSel ? 'var(--gz-fg)' :
                            st === 'a' ? 'var(--gz-card)' :
                            st === 'w' ? 'var(--gz-warn-bg)' :
                            'var(--gz-pill-bg)',
                          color:
                            isSel ? '#fff' :
                            st === 'w' ? 'var(--gz-warn)' :
                            st === 'b' ? 'var(--gz-fg-4)' :
                            'var(--gz-fg)',
                          border: 0, borderRadius: 10, textAlign: 'left',
                          fontFamily: 'var(--gz-mono)', fontSize: 12, fontWeight: 600,
                          textDecoration: disabled ? 'line-through' : 'none',
                          cursor: disabled ? 'not-allowed' : 'pointer',
                          display: 'flex', alignItems: 'center', gap: 6,
                        }}>
                        <span style={{
                          width: 6, height: 6, borderRadius: 999, flexShrink: 0,
                          background:
                            isSel ? 'var(--gz-card-tint-strong)' :
                            st === 'a' ? 'var(--gz-ok)' :
                            st === 'w' ? 'var(--gz-warn)' :
                            'var(--gz-rule)',
                        }} />
                        {t}
                      </button>
                    );
                  })}
                </div>

                {/* duration */}
                <div className="gz-meta" style={{ marginBottom: 10 }}>DURATION</div>
                <div style={{ display: 'flex', gap: 6, marginBottom: 18 }}>
                  {[1, 1.5, 2, 3].map(d => (
                    <button key={d} onClick={() => setDuration(d)}
                      style={{
                        flex: 1, padding: '12px 4px', border: 0,
                        background: duration === d ? 'var(--gz-fg)' : 'var(--gz-card)',
                        color: duration === d ? '#fff' : 'var(--gz-fg)',
                        borderRadius: 12, fontFamily: 'var(--gz-mono)',
                        fontSize: 14, fontWeight: 700,
                      }}>
                      {d}<span style={{ fontSize: 11, opacity: 0.7, marginLeft: 2 }}>hr</span>
                    </button>
                  ))}
                </div>

                {/* price preview */}
                <div className="gz-card gz-card--tint" style={{ marginBottom: 4 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                    <div>
                      <div className="gz-meta" style={{ color: 'var(--gz-fg-2)' }}>SELECTED</div>
                      <div className="gz-body" style={{ fontWeight: 700, marginTop: 4 }}>
                        {SLOTS_TIMES[slotIdx]} · <span className="gz-num">{duration}h</span>
                      </div>
                    </div>
                    <div style={{ textAlign: 'right' }}>
                      <div className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>
                        <span className="gz-num">{duration}h</span> × ₹{selectedSys.rate}
                      </div>
                      <div className="gz-hero-md" style={{ marginTop: 2 }}>₹{price}</div>
                    </div>
                  </div>
                </div>
              </Scroll>

              <div style={{ padding: '12px 16px 22px', background: 'var(--gz-bg)', flexShrink: 0,
                boxShadow: '0 -8px 16px -8px rgba(0,0,0,0.04)' }}>
                <button className="gz-btn">Select this slot · ₹{price}</button>
              </div>
            </>
          )}
        </div>
      </div>
    </Phone>
  );
}

function GridSystemCard({ sys, onTap }) {
  const tagFor = {
    free: <Tag kind="ok">Available now</Tag>,
    busy: <Tag kind="warn">Free at <span className="gz-num">{sys.free}</span></Tag>,
    down: <Tag kind="mute">Unavailable</Tag>,
  }[sys.state];

  return (
    <button onClick={onTap} disabled={sys.state === 'down'}
      style={{
        padding: 14, textAlign: 'left',
        background: sys.state === 'free' ? 'var(--gz-card-tint)' : 'var(--gz-card)',
        border: 0, borderRadius: 18,
        display: 'flex', flexDirection: 'column', gap: 10,
        opacity: sys.state === 'down' ? 0.55 : 1,
        cursor: sys.state === 'down' ? 'not-allowed' : 'pointer',
        minHeight: 150,
      }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div className="gz-tile gz-tile--sq" style={{
          width: 36, height: 36,
          background: sys.state === 'free' ? 'rgba(10,10,10,0.06)' : 'var(--gz-pill-bg)',
        }}>
          {React.cloneElement(I[sys.icon], { style: { width: 18, height: 18 } })}
        </div>
        <span className="gz-meta">{sys.type}</span>
      </div>
      <div style={{ flex: 1 }}>
        <div className="gz-body" style={{ fontWeight: 700 }}>{sys.name}</div>
        <div className="gz-small" style={{ marginTop: 2 }}>{sys.specs}</div>
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
        <span className="gz-body gz-num" style={{ fontWeight: 700 }}>
          ₹{sys.rate}<span className="gz-small" style={{ fontWeight: 500 }}> /hr</span>
        </span>
      </div>
      {tagFor}
    </button>
  );
}

function Legend({ dot, l }) {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 4, fontSize: 10, color: 'var(--gz-fg-3)', fontWeight: 600, letterSpacing: '0.04em', textTransform: 'uppercase' }}>
      <span style={{ width: 6, height: 6, borderRadius: 999, background: dot }} /> {l}
    </span>
  );
}

Object.assign(window, { SystemsBrowserScreen });
