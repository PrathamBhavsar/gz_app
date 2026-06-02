// Screen: Admin Player Analytics
function AdminPlayersScreen() {
  const topPlayers = [
    { letter: 'R', name: 'Rahul Mehra', mins: '420 min', idx: 0 },
    { letter: 'P', name: 'Priya Singh', mins: '380 min', idx: 1 },
    { letter: 'A', name: 'Amit Kumar', mins: '310 min', idx: 2 },
    { letter: 'N', name: 'Neha Reddy', mins: '290 min', idx: 3 },
    { letter: 'S', name: 'Suresh V.', mins: '245 min', idx: 4 },
  ];

  return (
    <Phone>
      <AdminTopBar title="Players" onBack={() => {}} />
      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* Segment breakdown */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Player segments</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{ flex: 1, textAlign: 'center' }}>
                <div className="gz-h1 gz-num">68</div>
                <div className="gz-small">New</div>
              </div>
              <div style={{ width: 1, height: 40, background: 'var(--gz-rule)' }} />
              <div style={{ flex: 1, textAlign: 'center' }}>
                <div className="gz-h1 gz-num">74</div>
                <div className="gz-small">Returning</div>
              </div>
            </div>
          </div>

          <div style={{ height: 12 }} />

          {/* Top players */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 12 }}>Top players · minutes</div>
            {topPlayers.map((p, i) => (
              <div key={i} style={{
                display: 'flex', alignItems: 'center', gap: 12, padding: '10px 0',
                borderTop: i > 0 ? '1px solid var(--gz-rule)' : 'none',
              }}>
                <span className="gz-body gz-num" style={{ width: 20, textAlign: 'center', color: 'var(--gz-fg-3)' }}>{i + 1}</span>
                <Avatar size="md" index={p.idx}>{p.letter}</Avatar>
                <div style={{ flex: 1 }}>
                  <div className="gz-body" style={{ fontWeight: 600 }}>{p.name}</div>
                </div>
                <span className="gz-small gz-num">{p.mins}</span>
                <span style={{ color: 'var(--gz-fg-3)' }}>
                  {React.cloneElement(I.chev, { style: { width: 14, height: 14 } })}
                </span>
              </div>
            ))}
          </div>

          <div style={{ height: 12 }} />

          {/* Summary stats */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <MetaRow label="Total players" value="142" />
            <MetaRow label="Active today" value="28" />
            <MetaRow label="Avg sessions/player" value="2.3" />
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminPlayersScreen });
