// Screen 16 — Profile Home + Notification Preferences (two-tab flow)
// Screen A: account hub with stats, menu, sign-out dialog.
// Screen B: notification toggles with micro-toast and push warning.

function ProfileHomeScreen() {
  const [screen, setScreen]         = useState('profile'); // 'profile' | 'notifs'
  const [signOutDlg, setSignOutDlg] = useState(false);

  // channel toggles
  const [channels, setChannels] = useState({ push: true, email: true, sms: false });
  // topic toggles
  const [prefs, setPrefs] = useState({
    bookConfirm: true, bookReminder: true, sessionWarn: true,
    credits: true, campaigns: false, disputes: true, newStores: false,
  });
  const [pushWarn, setPushWarn] = useState(false);
  const [microToast, setMicroToast] = useState(null);

  const flashToast = (msg) => {
    setMicroToast(msg);
    setTimeout(() => setMicroToast(null), 1500);
  };

  const toggleChannel = (k, v) => {
    setChannels(c => ({ ...c, [k]: v }));
    if (k === 'push') setPushWarn(!v);
    flashToast('Saved');
  };

  const togglePref = (k, v) => {
    setPrefs(p => ({ ...p, [k]: v }));
    flashToast('Saved');
  };

  const menuRows = [
    { label: 'Edit Profile',               chev: true },
    { label: 'Change Phone',               chev: true },
    { label: 'Notification Preferences',
      badge: <span style={{ width: 8, height: 8, borderRadius: 999,
        background: 'var(--gz-err)', display: 'inline-block' }} />,
      chev: true, onTap: () => setScreen('notifs') },
    { label: 'Billing History',            chev: true },
    { label: 'My Disputes',
      badge: <Tag kind="warn">1 open</Tag>, chev: true },
    { label: 'Help & Support',
      trail: (
        <svg viewBox="0 0 24 24" className="gz-ic" style={{ width: 16, height: 16, color: 'var(--gz-fg-3)' }}>
          <path d="M18 13v5a2 2 0 01-2 2H5a2 2 0 01-2-2V8a2 2 0 012-2h5M15 3h6v6M10 14L21 3"/>
        </svg>
      ), chev: false },
  ];

  const notifChannels = [
    { key: 'push',  label: 'Push notifications', sub: (v) => v ? 'Enabled on this device' : 'Disabled', toggleable: true },
    { key: 'email', label: 'Email',               sub: () => '',  toggleable: true },
    { key: 'sms',   label: 'SMS',                 sub: () => '',  toggleable: true },
    { key: 'inapp', label: 'In-app',              sub: () => 'Always on', toggleable: false },
  ];

  const notifPrefs = [
    { key: 'bookConfirm',  label: 'Booking confirmations' },
    { key: 'bookReminder', label: 'Booking reminders (1hr before)' },
    { key: 'sessionWarn',  label: 'Session ending soon (15min)' },
    { key: 'credits',      label: 'Credit updates' },
    { key: 'campaigns',    label: 'New campaigns' },
    { key: 'disputes',     label: 'Dispute status updates' },
    { key: 'newStores',    label: 'New stores nearby' },
  ];

  return (
    <Phone>
      <div style={{ position: 'relative', flex: 1, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>

        {/* ── Screen A: Profile Home ── */}
        <div style={{
          position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
          transform: screen === 'profile' ? 'translateX(0)' : 'translateX(-30%)',
          opacity: screen === 'profile' ? 1 : 0,
          transition: 'transform .35s cubic-bezier(.2,.7,.3,1), opacity .25s',
          pointerEvents: screen === 'profile' ? 'auto' : 'none',
          background: 'var(--gz-bg)',
        }}>
          <Scroll pad={false}>
            <div style={{ padding: '8px 16px 0' }}>

              {/* user card */}
              <div className="gz-card" style={{ padding: '22px 18px', marginBottom: 12 }}>
                <div style={{ display: 'flex', gap: 14, alignItems: 'center', marginBottom: 18 }}>
                  <div style={{
                    width: 64, height: 64, borderRadius: 999, flexShrink: 0,
                    background: 'var(--gz-card-tint)', color: 'var(--gz-fg)',
                    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                    fontSize: 26, fontWeight: 700, letterSpacing: '-0.04em',
                    fontFamily: 'var(--gz-font)',
                  }}>PM</div>
                  <div style={{ minWidth: 0 }}>
                    <div className="gz-h2" style={{ marginBottom: 2 }}>Pratham Mehta</div>
                    <div className="gz-small">pratham@gmail.com</div>
                    <div className="gz-small" style={{ marginTop: 2, color: 'var(--gz-fg-4)' }}>
                      Member since March 2024
                    </div>
                  </div>
                </div>

                {/* stats strip */}
                <div style={{ display: 'flex', borderTop: '1px solid var(--gz-rule)' }}>
                  {[
                    { n: '24',  l: 'sessions' },
                    { n: '48h', l: 'played' },
                    { n: '3',   l: 'stores' },
                  ].map((s, i) => (
                    <div key={i} style={{
                      flex: 1, textAlign: 'center', padding: '12px 4px',
                      borderLeft: i === 0 ? 0 : '1px solid var(--gz-rule)',
                    }}>
                      <div className="gz-body gz-num" style={{ fontWeight: 700 }}>{s.n}</div>
                      <div className="gz-small" style={{ marginTop: 2 }}>{s.l}</div>
                    </div>
                  ))}
                </div>
              </div>

              {/* menu */}
              <div className="gz-card" style={{ padding: 0, marginBottom: 12, overflow: 'hidden' }}>
                {menuRows.map((row, i) => (
                  <button key={i} onClick={row.onTap}
                    style={{
                      width: '100%', padding: '15px 18px',
                      background: 'transparent', border: 0, textAlign: 'left',
                      display: 'flex', alignItems: 'center', gap: 10,
                      borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)',
                      cursor: 'pointer',
                    }}>
                    <span className="gz-body" style={{ flex: 1, fontWeight: 600 }}>{row.label}</span>
                    {row.badge && <span style={{ display: 'inline-flex', alignItems: 'center' }}>{row.badge}</span>}
                    {row.trail && <span style={{ display: 'inline-flex', alignItems: 'center' }}>{row.trail}</span>}
                    {row.chev && (
                      <span style={{ color: 'var(--gz-fg-3)' }}>
                        {React.cloneElement(I.chev, { style: { width: 16, height: 16 } })}
                      </span>
                    )}
                  </button>
                ))}
              </div>

              {/* danger zone */}
              <div className="gz-meta" style={{ padding: '4px 4px 8px' }}>DANGER ZONE</div>
              <div className="gz-card" style={{ padding: 0, overflow: 'hidden', marginBottom: 16 }}>
                <button onClick={() => setSignOutDlg(true)}
                  style={{
                    width: '100%', padding: '16px 18px',
                    background: 'transparent', border: 0, textAlign: 'left', cursor: 'pointer',
                  }}>
                  <span style={{ fontSize: 14, fontWeight: 600, color: 'var(--gz-err)' }}>Sign out</span>
                </button>
              </div>
            </div>
          </Scroll>

          <BottomNav active="me" />

          {/* sign-out dialog */}
          {signOutDlg && (
            <div className="gz-sheet-overlay" onClick={() => setSignOutDlg(false)}
              style={{ alignItems: 'center', justifyContent: 'center', padding: 24 }}>
              <div onClick={e => e.stopPropagation()} style={{
                background: 'var(--gz-card)', borderRadius: 22, padding: 22,
                maxWidth: 320, width: '100%',
                animation: 'gz-slide-up 0.18s cubic-bezier(.2,.7,.3,1)',
              }}>
                <div className="gz-h1" style={{ marginBottom: 6 }}>Sign out?</div>
                <div className="gz-body-r" style={{ marginBottom: 20 }}>
                  You'll need to sign in again to access your bookings and credits.
                </div>
                <div style={{ display: 'flex', gap: 8 }}>
                  <button className="gz-btn gz-btn--ghost" onClick={() => setSignOutDlg(false)}>
                    Cancel
                  </button>
                  <button className="gz-btn" style={{ background: 'var(--gz-err)' }}
                    onClick={() => setSignOutDlg(false)}>
                    Sign out
                  </button>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* ── Screen B: Notification Preferences ── */}
        <div style={{
          position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
          transform: screen === 'notifs' ? 'translateX(0)' : 'translateX(100%)',
          transition: 'transform .35s cubic-bezier(.2,.7,.3,1)',
          background: 'var(--gz-bg)',
        }}>
          <TopBar title="Notifications" onBack={() => setScreen('profile')} />

          <Scroll>
            {/* push-off warning */}
            {pushWarn && (
              <div style={{
                padding: '12px 14px', marginBottom: 12,
                background: 'var(--gz-warn-bg)', borderRadius: 13,
                display: 'flex', gap: 10, alignItems: 'flex-start',
                animation: 'gz-slide-up 0.18s ease-out',
              }}>
                {React.cloneElement(I.warnT, {
                  style: { width: 18, height: 18, color: 'var(--gz-warn)', flexShrink: 0, marginTop: 1 }
                })}
                <span style={{ fontSize: 13, fontWeight: 500, color: 'var(--gz-warn)', lineHeight: 1.45 }}>
                  You'll miss session reminders and booking confirmations
                </span>
              </div>
            )}

            {/* channels */}
            <div className="gz-meta" style={{ padding: '0 4px 10px' }}>HOW TO NOTIFY YOU</div>
            <div className="gz-card" style={{ padding: 0, marginBottom: 18, overflow: 'hidden' }}>
              {notifChannels.map((ch, i) => {
                const on = ch.key === 'inapp' ? true : channels[ch.key];
                const sub = ch.sub(on);
                return (
                  <div key={i} style={{
                    padding: '14px 18px', display: 'flex', alignItems: 'center', gap: 12,
                    borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)',
                    opacity: !ch.toggleable ? 0.5 : 1,
                  }}>
                    <div style={{ flex: 1 }}>
                      <div className="gz-body" style={{ fontWeight: 600 }}>{ch.label}</div>
                      {sub && <div className="gz-small" style={{ marginTop: 2 }}>{sub}</div>}
                    </div>
                    <GzPrefToggle on={on} disabled={!ch.toggleable}
                      onChange={v => ch.toggleable && toggleChannel(ch.key, v)} />
                  </div>
                );
              })}
            </div>

            {/* topics */}
            <div className="gz-meta" style={{ padding: '0 4px 10px' }}>WHAT TO NOTIFY YOU ABOUT</div>
            <div className="gz-card" style={{ padding: 0, marginBottom: 18, overflow: 'hidden' }}>
              {notifPrefs.map((p, i) => (
                <div key={i} style={{
                  padding: '14px 18px', display: 'flex', alignItems: 'center', gap: 12,
                  borderTop: i === 0 ? 0 : '1px solid var(--gz-rule)',
                }}>
                  <span className="gz-body" style={{ flex: 1, fontWeight: 600, fontSize: 14 }}>
                    {p.label}
                  </span>
                  <GzPrefToggle on={prefs[p.key]} onChange={v => togglePref(p.key, v)} />
                </div>
              ))}
            </div>
          </Scroll>

          {/* micro-toast */}
          {microToast && (
            <div style={{
              position: 'absolute', left: '50%', transform: 'translateX(-50%)',
              bottom: 20, whiteSpace: 'nowrap',
              padding: '8px 18px', borderRadius: 999,
              background: 'var(--gz-fg)', color: '#fff',
              fontSize: 12, fontWeight: 600,
              animation: 'gz-slide-up 0.15s cubic-bezier(.2,.7,.3,1)',
              zIndex: 80,
            }}>
              {microToast}
            </div>
          )}
        </div>
      </div>
    </Phone>
  );
}

// Toggle pill — unique name to avoid collision
function GzPrefToggle({ on, disabled = false, onChange }) {
  return (
    <button onClick={() => !disabled && onChange(!on)} style={{
      width: 46, height: 27, borderRadius: 999, padding: 3,
      background: on ? 'var(--gz-fg)' : 'var(--gz-rule)',
      border: 0, cursor: disabled ? 'default' : 'pointer',
      display: 'flex', alignItems: 'center',
      justifyContent: on ? 'flex-end' : 'flex-start',
      transition: 'background .2s', flexShrink: 0,
    }}>
      <span style={{
        width: 21, height: 21, borderRadius: 999, background: '#fff',
        boxShadow: '0 1px 3px rgba(0,0,0,0.18)', display: 'block',
      }} />
    </button>
  );
}

Object.assign(window, { ProfileHomeScreen });
