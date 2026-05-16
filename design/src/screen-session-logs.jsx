function SessionLogsScreen() {
  const [filterType, setFilterType] = React.useState('all'); // 'all' | 'system' | 'alerts' | 'activity'
  const [pullRefresh, setPullRefresh] = React.useState(false);

  const allEvents = [
    { id: 1, time: '6:01 PM', type: 'alert', icon: I.warnT, title: '5-minute warning sent', avatarIndex: 3 },
    { id: 2, time: '5:58 PM', type: 'activity', icon: I.games, title: 'Controller disconnected briefly', avatarIndex: 6, muted: true },
    { id: 3, time: '5:30 PM', type: 'alert', icon: I.info, title: '1-hour remaining alert', avatarIndex: 4 },
    { id: 4, time: '5:15 PM', type: 'system', icon: I.spark, title: 'System activity: high GPU load detected', avatarIndex: 1 },
    { id: 5, time: '4:45 PM', type: 'system', icon: I.games, title: 'System activity: game launched', avatarIndex: 1 },
    { id: 6, time: '4:32 PM', type: 'alert', icon: I.clock, title: 'Brief inactivity detected (4 min)', avatarIndex: 5 },
    { id: 7, time: '4:12 PM', type: 'system', icon: I.pc, title: 'System activity: application opened', avatarIndex: 1 },
    { id: 8, time: '4:03 PM', type: 'system', icon: I.spark, title: 'System activity detected', avatarIndex: 1 },
    { id: 9, time: '4:00 PM', type: 'system', icon: I.check, title: 'Session started', avatarIndex: 0, large: true }
  ];

  const filterChips = [
    { label: 'All', value: 'all' },
    { label: 'System', value: 'system' },
    { label: 'Alerts', value: 'alerts' },
    { label: 'Activity', value: 'activity' }
  ];

  const filteredEvents = filterType === 'all' 
    ? allEvents 
    : allEvents.filter(e => {
        if (filterType === 'alerts') return e.type === 'alert';
        return e.type === filterType;
      });

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--gz-bg)' }}>
      {/* Header */}
      <div style={{ padding: '16px 20px', borderBottom: '1px solid var(--gz-rule)' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
          <button style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--gz-fg)', width: 38, height: 38, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {React.cloneElement(I.back, { style: { width: 24, height: 24 } })}
          </button>
          <div style={{ fontSize: 18, fontWeight: 700, color: 'var(--gz-fg)' }}>Session events</div>
          <div style={{ marginLeft: 'auto', fontSize: 11, color: 'var(--gz-fg-3)', fontFamily: 'var(--gz-mono)' }}>
            #SES-20948
          </div>
        </div>

        {/* Context strip */}
        <div style={{
          background: 'var(--gz-card)',
          padding: '10px 12px',
          borderRadius: 6,
          fontSize: 12,
          color: 'var(--gz-fg-2)',
          fontWeight: 500,
          marginBottom: 12
        }}>
          RTX 4090 · Seat 3 · GameZone Koramangala · In progress
        </div>

        {/* Live indicator */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 12 }}>
          <div style={{
            width: 8,
            height: 8,
            borderRadius: '50%',
            background: 'var(--gz-ok)',
            animation: 'pulse 1.6s ease-out infinite'
          }} />
          <span style={{ fontSize: 11, fontWeight: 600, color: 'var(--gz-ok)' }}>Updating live</span>
        </div>

        {/* Filter chips */}
        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', scrollBehavior: 'smooth' }}>
          {filterChips.map(chip => (
            <button
              key={chip.value}
              onClick={() => setFilterType(chip.value)}
              style={{
                padding: '6px 12px',
                background: filterType === chip.value ? 'var(--gz-fg)' : 'var(--gz-card)',
                color: filterType === chip.value ? 'var(--gz-bg)' : 'var(--gz-fg)',
                border: filterType === chip.value ? 'none' : '1px solid var(--gz-rule)',
                borderRadius: 6,
                fontSize: 12,
                fontWeight: 600,
                cursor: 'pointer',
                whiteSpace: 'nowrap',
                flexShrink: 0
              }}
            >
              {chip.label}
            </button>
          ))}
        </div>
      </div>

      {/* Events timeline */}
      <div style={{
        flex: 1,
        overflowY: 'auto',
        padding: '16px 20px',
        position: 'relative'
      }}>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          {filteredEvents.map((event, idx) => (
            <div
              key={event.id}
              style={{
                display: 'flex',
                gap: 12,
                padding: '12px',
                borderRadius: 8,
                cursor: 'pointer',
                transition: 'background 0.2s ease',
                ':hover': { background: 'var(--gz-card)' },
                animation: pullRefresh && idx === 0 ? 'flash 0.6s ease-out' : 'none'
              }}
              onMouseEnter={(e) => e.currentTarget.style.background = 'var(--gz-card)'}
              onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
            >
              {/* Time */}
              <div style={{
                fontSize: 11,
                fontFamily: 'var(--gz-mono)',
                color: 'var(--gz-fg-3)',
                minWidth: 50,
                flexShrink: 0
              }}>
                {event.time}
              </div>

              {/* Icon circle - Walle-inspired avatar */}
              <div style={{ opacity: event.muted ? 0.4 : 1 }}>
                <Avatar 
                  size={event.large ? 'lg' : 'sm'} 
                  index={event.avatarIndex}
                  icon={event.icon}
                />
              </div>

              {/* Description */}
              <div style={{
                flex: 1,
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'center',
                fontSize: event.large ? 14 : 13,
                fontWeight: event.large ? 700 : 500,
                color: 'var(--gz-fg)'
              }}>
                {event.title}
              </div>
            </div>
          ))}
        </div>
      </div>

      <style>{`
        @keyframes pulse {
          0%   { box-shadow: 0 0 0 0 rgba(46,122,60,0.55); }
          70%  { box-shadow: 0 0 0 8px rgba(46,122,60,0); }
          100% { box-shadow: 0 0 0 0 rgba(46,122,60,0); }
        }
        @keyframes flash {
          0% { background: rgba(46,122,60,0.1); }
          100% { background: transparent; }
        }
      `}</style>
    </div>
  );
}

Object.assign(window, { SessionLogsScreen });
