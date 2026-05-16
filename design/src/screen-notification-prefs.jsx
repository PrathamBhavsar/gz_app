// S-34 — Notification Preferences
// Standalone pushed screen; accessed from Profile Home → "Notification Preferences"
// Same push-screen pattern as screen-change-phone.jsx / screen-billing-history.jsx

// ── Toggle ────────────────────────────────────────────────────────────────────
// Unique name to avoid collision with GzPrefToggle in screen-profile-home.jsx
function NotifPrefToggle({ on, disabled = false, onChange }) {
  return (
    <button
      onClick={() => !disabled && onChange && onChange(!on)}
      style={{
        width: 50, height: 30, borderRadius: 999,
        padding: '2px 3px',
        background: on ? 'var(--gz-fg)' : 'var(--gz-rule)',
        border: 0, cursor: disabled ? 'default' : 'pointer',
        display: 'flex', alignItems: 'center',
        justifyContent: on ? 'flex-end' : 'flex-start',
        transition: 'background .18s ease', flexShrink: 0,
      }}
    >
      <span style={{
        width: 26, height: 26, borderRadius: 999,
        background: '#fff',
        boxShadow: '0 1px 3px rgba(0,0,0,0.25)',
        display: 'block',
        flexShrink: 0,
      }} />
    </button>
  );
}

// ── Icon tile (36×36, bg #F4F4F1, radius 10) ─────────────────────────────────
function NotifIconTile({ icon }) {
  return (
    <div style={{
      width: 36, height: 36, borderRadius: 10, flexShrink: 0,
      background: 'var(--gz-pill-bg)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      color: 'var(--gz-fg-2)',
    }}>
      {React.cloneElement(icon, { style: { width: 17, height: 17 } })}
    </div>
  );
}

// ── Extra icons not in the shared I set ──────────────────────────────────────
const INotif = {
  mail:      <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg>,
  bellDot:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M18 16H6l1.5-2V11a4.5 4.5 0 019 0v3L18 16z"/><path d="M10.5 19a1.5 1.5 0 003 0"/><circle cx="18" cy="5" r="3.5" fill="currentColor" stroke="none"/></svg>,
  calCheck:  <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3.5" y="5" width="17" height="15" rx="2"/><path d="M3.5 10h17M8 3v4M16 3v4M9 15l2 2 4-4"/></svg>,
  alarm:     <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="12" cy="13.5" r="7"/><path d="M12 10.5v3l2 1.5M4.5 5.5l-2 2M19.5 5.5l2 2"/></svg>,
  hourglass: <svg viewBox="0 0 24 24" className="gz-ic"><path d="M6 4h12M6 20h12M8 4v5l4 3-4 3v4M16 4v5l-4 3 4 3v4"/></svg>,
  tag:       <svg viewBox="0 0 24 24" className="gz-ic"><path d="M3.5 9.5V4h5.5L19 13.9a2 2 0 010 2.8l-3.3 3.3a2 2 0 01-2.8 0L3.5 9.5z"/><circle cx="9" cy="9" r="1.5"/></svg>,
  shield:    <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 3l8 3v5c0 5-3.5 8.8-8 10-4.5-1.2-8-5-8-10V6l8-3z"/><path d="M9 12l2 2 4-4"/></svg>,
};

// ── Main screen ───────────────────────────────────────────────────────────────
function NotificationPrefsScreen({ initialPushOff = false }) {
  const [channels, setChannels] = React.useState({
    push:  !initialPushOff,
    email: true,
    sms:   false,
  });
  const [prefs, setPrefs] = React.useState({
    bookConfirm:  true,
    bookReminder: true,
    sessionWarn:  true,
    credits:      true,
    campaigns:    false,
    disputes:     true,
  });
  const [toast, setToast] = React.useState(null);

  const flashToast = (msg) => {
    setToast(msg);
    setTimeout(() => setToast(null), 1500);
  };

  const toggleChannel = (k, v) => {
    setChannels(c => ({ ...c, [k]: v }));
    flashToast('Saved');
  };

  const togglePref = (k, v) => {
    setPrefs(p => ({ ...p, [k]: v }));
    flashToast('Saved');
  };

  const pushOff = !channels.push;

  // ── Channel rows ──────────────────────────────────────────────────────────
  const channelRows = [
    {
      key: 'push',
      icon: I.bell,
      label: 'Push',
      sub: 'Alerts on your device',
      toggleable: true,
    },
    {
      key: 'email',
      icon: INotif.mail,
      label: 'Email',
      sub: 'Sent to your registered email',
      toggleable: true,
    },
    {
      key: 'sms',
      icon: I.chat,
      label: 'SMS',
      sub: 'Text messages to your phone',
      toggleable: true,
    },
    {
      key: 'inapp',
      icon: INotif.bellDot,
      label: 'In-App',
      sub: 'Always on — bell icon in home',
      toggleable: false,
      forceOn: true,
    },
  ];

  // ── Pref rows ─────────────────────────────────────────────────────────────
  const prefRows = [
    { key: 'bookConfirm',  icon: INotif.calCheck,  label: 'Booking confirmed',    sub: 'When a slot booking is accepted'      },
    { key: 'bookReminder', icon: INotif.alarm,      label: 'Booking reminders',    sub: '1 hour before your session starts'    },
    { key: 'sessionWarn',  icon: INotif.hourglass,  label: 'Session ending soon',  sub: '15 minutes before time runs out'      },
    { key: 'credits',      icon: I.coin,            label: 'Credit updates',       sub: 'When credits are earned or expire'    },
    { key: 'campaigns',    icon: INotif.tag,        label: 'New campaigns',        sub: 'Deals and offers at your stores'      },
    { key: 'disputes',     icon: INotif.shield,     label: 'Dispute updates',      sub: 'Status changes on your disputes'      },
  ];

  return (
    <Phone>
      <TopBar title="Notifications" onBack={() => {}} />

      <Scroll>

        {/* ── Section 1: Channels ── */}
        <div className="gz-meta" style={{ padding: '0 4px 10px' }}>DELIVERY CHANNELS</div>
        <div className="gz-card" style={{ padding: 0, marginBottom: 20, overflow: 'hidden' }}>
          {channelRows.map((row, i) => {
            const on = row.forceOn ? true : !!channels[row.key];
            return (
              <div key={row.key} style={{
                borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)',
                opacity: !row.toggleable ? 0.5 : 1,
              }}>
                {/* Row */}
                <div style={{
                  padding: '15px 18px',
                  display: 'flex', alignItems: 'center', gap: 12,
                }}>
                  <NotifIconTile icon={row.icon} />
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div className="gz-body" style={{ fontWeight: 600, color: 'var(--gz-fg)' }}>{row.label}</div>
                    <div className="gz-small" style={{ marginTop: 2 }}>{row.sub}</div>
                  </div>
                  <NotifPrefToggle
                    on={on}
                    disabled={!row.toggleable}
                    onChange={v => row.toggleable && toggleChannel(row.key, v)}
                  />
                </div>

                {/* Push ON chip */}
                {row.key === 'push' && on && (
                  <div style={{
                    margin: '-4px 18px 12px',
                    padding: '6px 10px',
                    background: 'var(--gz-pill-bg)',
                    borderRadius: 8,
                    animation: 'gz-slide-up 0.15s ease-out',
                  }}>
                    <span className="gz-small">Tap allows system permission request</span>
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* ── Section 2: Notify me when ── */}
        <div className="gz-meta" style={{ padding: '0 4px 10px' }}>NOTIFY ME WHEN</div>
        <div className="gz-card" style={{ padding: 0, marginBottom: 12, overflow: 'hidden' }}>

          {/* Push-off warning banner */}
          {pushOff && (
            <div style={{
              margin: '12px 14px 8px',
              padding: '10px 14px',
              background: 'var(--gz-warn-bg)',
              borderRadius: 12,
              display: 'flex', gap: 8, alignItems: 'flex-start',
              animation: 'gz-slide-up 0.18s ease-out',
            }}>
              {React.cloneElement(I.warnT, {
                style: { width: 16, height: 16, color: 'var(--gz-warn)', flexShrink: 0, marginTop: 1 },
              })}
              <span style={{ fontSize: 12, fontWeight: 500, color: 'var(--gz-warn)', lineHeight: 1.45 }}>
                Push is off — some alerts may not reach you.
              </span>
            </div>
          )}

          {prefRows.map((row, i) => (
            <div key={row.key} style={{
              padding: '14px 18px',
              display: 'flex', alignItems: 'center', gap: 12,
              borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)',
            }}>
              <NotifIconTile icon={row.icon} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div className="gz-body" style={{ fontWeight: 600, color: 'var(--gz-fg)' }}>{row.label}</div>
                <div className="gz-small" style={{ marginTop: 2 }}>{row.sub}</div>
              </div>
              <NotifPrefToggle
                on={!!prefs[row.key]}
                onChange={v => togglePref(row.key, v)}
              />
            </div>
          ))}
        </div>

        {/* Bottom note */}
        <div style={{ textAlign: 'center', padding: '4px 0 20px' }}>
          <span className="gz-small">Changes save automatically</span>
        </div>
      </Scroll>

      {/* Micro-toast */}
      {toast && (
        <div style={{
          position: 'absolute', left: '50%', transform: 'translateX(-50%)',
          bottom: 20, whiteSpace: 'nowrap',
          padding: '8px 18px', borderRadius: 999,
          background: 'var(--gz-fg)', color: '#fff',
          fontSize: 12, fontWeight: 600, letterSpacing: '-0.01em',
          animation: 'gz-slide-up 0.15s cubic-bezier(.2,.7,.3,1)',
          zIndex: 80, pointerEvents: 'none',
        }}>
          {toast}
        </div>
      )}
    </Phone>
  );
}

Object.assign(window, { NotificationPrefsScreen });
