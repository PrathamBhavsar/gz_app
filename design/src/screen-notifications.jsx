// Screen 6 — Notification Center
// Bell-icon overlay. Read/unread state, mark-all, expandable rows with action.

const INITIAL_NOTIFS = [
  { id: 'n1', icon: 'clock', kind: 'info',  read: false, title: 'Your session starts in 30 min',
    body: 'GameZone Koramangala, Seat 3. Make sure to check in 5 minutes before 4:00 PM to avoid auto-release of the slot.',
    when: '28 min ago', action: 'View booking →' },
  { id: 'n2', icon: 'check', kind: 'ok',    read: false, title: 'Payment confirmed — ₹82',
    body: 'Your booking for Sat, 18 Apr (RTX 4090 — Seat 3) is paid in full. A receipt has been emailed to you.',
    when: '2 hrs ago', action: 'View receipt →' },
  { id: 'n3', icon: 'star',  kind: 'ok',    read: false, title: '850 credits earned this month',
    body: 'You hit our top tier. Use them at GameZone Koramangala for up to ₹85 off your next session.',
    when: '5 hrs ago', action: 'Open wallet →' },
  { id: 'n4', icon: 'bell',  kind: 'warn',  read: true,  title: 'Happy Hour ends tomorrow',
    body: '30% off all weekday sessions between 10am and 2pm — last day to claim is tomorrow.',
    when: 'Yesterday', action: 'View campaign →' },
  { id: 'n5', icon: 'info',  kind: 'info',  read: true,  title: 'Dispute #DIS-0042 resolved',
    body: 'Full refund of ₹80 has been issued back to your original UPI account. May take 2–3 business days to reflect.',
    when: '2 days ago', action: 'View dispute →' },
  { id: 'n6', icon: 'pin',   kind: 'purple', read: true, title: 'New store added near you',
    body: 'GameZone Whitefield is now live, with 18 PC stations and 6 PS5s. 8 km from your last booking.',
    when: '3 days ago', action: 'Explore store →' },
  { id: 'n7', icon: 'pad',   kind: 'mute',  read: true,  title: 'Session completed — ₹160 charged',
    body: '2 hours at GameZone MG Road on an RTX 3080. You earned 80 credits.',
    when: '4 days ago', action: 'View session →' },
];

const ICON_FOR = { clock: 'clock', check: 'check', star: 'star', bell: 'bell', info: 'info', pin: 'pin', pad: 'pad' };

function NotificationsScreen() {
  const [notifs, setNotifs] = useState(INITIAL_NOTIFS);
  const [expanded, setExpanded] = useState(null);

  const unread = notifs.filter(n => !n.read).length;

  const toggleOpen = (id) => {
    setExpanded(e => e === id ? null : id);
    setNotifs(ns => ns.map(n => n.id === id ? { ...n, read: true } : n));
  };

  return (
    <Phone>
      <div style={{ padding: '4px 16px 0', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexShrink: 0 }}>
        <IconBtn onClick={() => {}}>{I.x}</IconBtn>
        <h1 className="gz-h2">Notifications</h1>
        <button onClick={() => setNotifs(ns => ns.map(n => ({ ...n, read: true })))}
          style={{ background: 'transparent', border: 0, padding: 4,
            fontSize: 12, fontWeight: 600, color: unread ? 'var(--gz-fg)' : 'var(--gz-fg-4)',
            cursor: unread ? 'pointer' : 'default',
          }}>
          Mark all read
        </button>
      </div>

      <div style={{ padding: '12px 20px 12px', flexShrink: 0 }}>
        <Tag kind={unread > 0 ? 'info' : 'mute'}>
          <span className="gz-num" style={{ fontWeight: 700 }}>{unread}</span>
          <span style={{ marginLeft: 4 }}>{unread === 1 ? 'unread' : 'unread'}</span>
        </Tag>
      </div>

      <Scroll pad={false}>
        {notifs.map((n, i) => {
          const open = expanded === n.id;
          return (
            <div key={n.id} style={{
              background: n.read ? 'transparent' : 'rgba(220, 227, 242, 0.35)', // info-bg @ 35% — soft unread halo
              borderTop: i === 0 ? '1px solid var(--gz-rule)' : 0,
              borderBottom: '1px solid var(--gz-rule)',
              transition: 'background .3s',
            }}>
              <button onClick={() => toggleOpen(n.id)}
                style={{ width: '100%', padding: '14px 20px',
                  background: 'transparent', border: 0, textAlign: 'left',
                  display: 'flex', alignItems: 'flex-start', gap: 12, cursor: 'pointer' }}>
                <span style={{ width: 8, height: 8, marginTop: 14, marginRight: -4,
                  borderRadius: 999, background: n.read ? 'transparent' : 'var(--gz-info)',
                  flexShrink: 0,
                }} />
                <NotifIcon kind={n.kind} icon={I[ICON_FOR[n.icon]]} />
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', gap: 10, alignItems: 'baseline' }}>
                    <span className="gz-body" style={{ fontWeight: n.read ? 500 : 700, color: 'var(--gz-fg)',
                      flex: 1, minWidth: 0,
                      whiteSpace: open ? 'normal' : 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                    }}>{n.title}</span>
                    <span className="gz-small" style={{ flexShrink: 0 }}>{n.when}</span>
                  </div>
                  <div className="gz-body-r" style={{ fontSize: 13, marginTop: 3,
                    whiteSpace: open ? 'normal' : 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                  }}>{n.body}</div>
                  {open && (
                    <div style={{ marginTop: 12 }}>
                      <span style={{ fontSize: 13, fontWeight: 600, color: 'var(--gz-fg)', textDecoration: 'underline' }}>
                        {n.action}
                      </span>
                    </div>
                  )}
                </div>
              </button>
            </div>
          );
        })}
      </Scroll>
    </Phone>
  );
}

function NotifIcon({ kind, icon }) {
  const palettes = {
    ok:     { bg: 'var(--gz-ok-bg)',     fg: 'var(--gz-ok)' },
    warn:   { bg: 'var(--gz-warn-bg)',   fg: 'var(--gz-warn)' },
    err:    { bg: 'var(--gz-err-bg)',    fg: 'var(--gz-err)' },
    info:   { bg: 'var(--gz-info-bg)',   fg: 'var(--gz-info)' },
    purple: { bg: 'var(--gz-purple-bg)', fg: 'var(--gz-purple)' },
    mute:   { bg: 'var(--gz-pill-bg)',   fg: 'var(--gz-fg-2)' },
  };
  const p = palettes[kind] || palettes.mute;
  return (
    <div style={{
      width: 36, height: 36, borderRadius: 999, flexShrink: 0,
      background: p.bg, color: p.fg,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
    }}>
      {React.cloneElement(icon, { style: { width: 17, height: 17 } })}
    </div>
  );
}

Object.assign(window, { NotificationsScreen });
