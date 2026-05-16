function FullAppFlowDemo() {
  const [activeTab, setActiveTab] = React.useState('home');
  const [sessionActive, setSessionActive] = React.useState(true);
  const [notificationCount, setNotificationCount] = React.useState(3);
  const [showNotificationSheet, setShowNotificationSheet] = React.useState(false);

  const tabs = [
    { id: 'home', label: 'Home', icon: I.home },
    { id: 'book', label: 'Book', icon: I.book },
    { id: 'games', label: 'My Games', icon: I.games },
    { id: 'wallet', label: 'Wallet', icon: I.wallet },
    { id: 'profile', label: 'Profile', icon: I.user }
  ];

  const renderTabContent = () => {
    switch (activeTab) {
      case 'home':
        return (
          <div style={{ padding: '16px', paddingBottom: 80 }}>
            {/* Active session banner */}
            {sessionActive && (
              <div style={{
                background: 'var(--gz-card-tint)',
                padding: 12,
                borderRadius: 12,
                marginBottom: 16,
                display: 'flex',
                alignItems: 'center',
                gap: 12
              }}>
                <div style={{ width: 32, height: 32, display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--gz-ok)' }}>
                  {React.cloneElement(I.games, { style: { width: 20, height: 20 } })}
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)' }}>Active now</div>
                  <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>RTX 4090 · 1:47:23 left</div>
                </div>
              </div>
            )}

            {/* Store cards */}
            <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: '0.12em' }}>Nearby stores</div>
            {[1, 2].map(i => (
              <div key={i} style={{
                background: 'var(--gz-card)',
                padding: 12,
                borderRadius: 12,
                marginBottom: 12,
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center'
              }}>
                <div>
                  <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--gz-fg)' }}>GameZone {i === 1 ? 'Koramangala' : 'MG Road'}</div>
                  <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>{i === 1 ? '1.2 km' : '2.8 km'} · Open now</div>
                </div>
                <button style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--gz-fg-2)' }}>
                  {React.cloneElement(I.chev, { style: { width: 20, height: 20 } })}
                </button>
              </div>
            ))}

            {/* Upcoming booking */}
            <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 8, marginTop: 16, letterSpacing: '0.12em' }}>Upcoming</div>
            <div style={{
              background: 'var(--gz-card)',
              padding: 12,
              borderRadius: 12,
              marginBottom: 12
            }}>
              <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 4 }}>Sat, 25 May · 6:00 PM</div>
              <div style={{ fontSize: 12, color: 'var(--gz-fg-2)' }}>RTX 4090 at GameZone Koramangala</div>
            </div>
          </div>
        );

      case 'book':
        return (
          <div style={{ padding: '16px', paddingBottom: 80 }}>
            <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 12, letterSpacing: '0.12em' }}>Featured systems</div>
            {['RTX 4090', 'RTX 3080', 'PS5 Pro', 'Xbox Series X'].map((sys, i) => (
              <div key={i} style={{
                background: 'var(--gz-card)',
                padding: 12,
                borderRadius: 12,
                marginBottom: 12,
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center'
              }}>
                <div>
                  <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--gz-fg)' }}>{sys}</div>
                  <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>₹499/hr</div>
                </div>
                <button style={{ background: 'none', border: 'none', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--gz-fg-2)' }}>
                  {React.cloneElement(I.chev, { style: { width: 20, height: 20 } })}
                </button>
              </div>
            ))}
          </div>
        );

      case 'games':
        return (
          <div style={{ padding: '16px', paddingBottom: 80 }}>
            <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
              {['Upcoming', 'Active', 'History'].map(tab => (
                <button key={tab} style={{
                  padding: '6px 12px',
                  background: tab === 'Upcoming' ? 'var(--gz-fg)' : 'var(--gz-card)',
                  color: tab === 'Upcoming' ? 'var(--gz-bg)' : 'var(--gz-fg)',
                  border: tab === 'Upcoming' ? 'none' : '1px solid var(--gz-rule)',
                  borderRadius: 6,
                  fontSize: 12,
                  fontWeight: 600,
                  cursor: 'pointer'
                }}>
                  {tab}
                </button>
              ))}
            </div>

            {sessionActive && (
              <>
                <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: '0.12em' }}>Active</div>
                <div style={{
                  background: 'var(--gz-card-tint)',
                  padding: 12,
                  borderRadius: 12,
                  marginBottom: 16
                }}>
                  <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 4 }}>RTX 4090 — Seat 3</div>
                  <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>1:47:23 remaining</div>
                </div>
              </>
            )}

            <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: '0.12em' }}>Upcoming</div>
            <div style={{
              background: 'var(--gz-card)',
              padding: 12,
              borderRadius: 12,
              marginBottom: 12
            }}>
              <div style={{ fontSize: 13, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 4 }}>Sat, 25 May · 6:00 PM</div>
              <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>RTX 4090 at GameZone Koramangala</div>
            </div>
          </div>
        );

      case 'wallet':
        return (
          <div style={{ padding: '16px', paddingBottom: 80 }}>
            {/* Balance hero */}
            <div style={{
              background: 'var(--gz-fg)',
              color: 'var(--gz-bg)',
              padding: 20,
              borderRadius: 16,
              marginBottom: 20,
              textAlign: 'center'
            }}>
              <div style={{ fontSize: 11, fontWeight: 600, opacity: 0.7, marginBottom: 8 }}>Current balance</div>
              <div style={{ fontSize: 32, fontWeight: 700, fontFamily: 'var(--gz-mono)' }}>₹4,850</div>
            </div>

            {/* Transactions */}
            <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: '0.12em' }}>Recent transactions</div>
            {[
              { desc: 'Session credit refund', amt: '+₹1,200' },
              { desc: 'Session booking', amt: '-₹499' },
              { desc: 'Campaign bonus', amt: '+₹500' }
            ].map((tx, i) => (
              <div key={i} style={{
                background: 'var(--gz-card)',
                padding: 12,
                borderRadius: 12,
                marginBottom: 8,
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center'
              }}>
                <div style={{ fontSize: 13, color: 'var(--gz-fg)', fontWeight: 500 }}>{tx.desc}</div>
                <div style={{ fontSize: 12, fontWeight: 600, color: tx.amt.startsWith('+') ? 'var(--gz-ok)' : 'var(--gz-fg)' }}>{tx.amt}</div>
              </div>
            ))}

            {/* Campaigns */}
            <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 8, marginTop: 16, letterSpacing: '0.12em' }}>Active campaigns</div>
            {[1, 2].map(i => (
              <div key={i} style={{
                background: 'var(--gz-card)',
                padding: 12,
                borderRadius: 12,
                marginBottom: 12
              }}>
                <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 4 }}>Campaign {i}</div>
                <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>Earn ₹{i * 500} on next booking</div>
              </div>
            ))}
          </div>
        );

      case 'profile':
        return (
          <div style={{ padding: '16px', paddingBottom: 80 }}>
            {/* User card */}
            <div style={{
              background: 'var(--gz-card)',
              padding: 16,
              borderRadius: 12,
              marginBottom: 20,
              display: 'flex',
              gap: 12,
              alignItems: 'center'
            }}>
              <Avatar size="xl" bg="var(--gz-card-tint)">👤</Avatar>
              <div>
                <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--gz-fg)' }}>Pratham</div>
                <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>pratham@gmail.com</div>
              </div>
            </div>

            {/* Stats */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 20 }}>
              {[
                { label: 'Total bookings', val: '24' },
                { label: 'Lifetime spent', val: '₹12.4k' }
              ].map((stat, i) => (
                <div key={i} style={{
                  background: 'var(--gz-card)',
                  padding: 12,
                  borderRadius: 12,
                  textAlign: 'center'
                }}>
                  <div style={{ fontSize: 12, fontWeight: 700, color: 'var(--gz-fg)', marginBottom: 4 }}>{stat.val}</div>
                  <div style={{ fontSize: 10, color: 'var(--gz-fg-3)' }}>{stat.label}</div>
                </div>
              ))}
            </div>

            {/* Menu */}
            <div style={{ fontSize: 10, fontWeight: 700, color: 'var(--gz-fg-3)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: '0.12em' }}>Account</div>
            {['Edit profile', 'Payment methods', 'Notification settings', 'Support', 'Terms & privacy', 'Sign out'].map((item, i) => (
              <button key={i} style={{
                width: '100%',
                padding: '12px 16px',
                background: 'var(--gz-card)',
                border: 'none',
                borderRadius: 12,
                marginBottom: 8,
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                color: 'var(--gz-fg)',
                fontSize: 13,
                fontWeight: 500,
                cursor: 'pointer'
              }}>
                {item}
                <span style={{ color: 'var(--gz-fg-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  {React.cloneElement(I.chev, { style: { width: 18, height: 18 } })}
                </span>
              </button>
            ))}
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      height: '100%',
      background: 'var(--gz-bg)',
      position: 'relative'
    }}>
      {/* Status bar */}
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: '14px 24px 6px',
        fontFamily: 'var(--gz-font)',
        fontSize: 14,
        fontWeight: 600,
        color: 'var(--gz-fg)',
        flexShrink: 0
      }}>
        <span>9:41</span>
        <span style={{ display: 'inline-flex', gap: 4, alignItems: 'center' }}>
          <svg width="16" height="10" viewBox="0 0 16 10"><rect x="0" y="6" width="2.4" height="3.5" rx="0.5" fill="currentColor"/><rect x="3.6" y="4" width="2.4" height="5.5" rx="0.5" fill="currentColor"/><rect x="7.2" y="2" width="2.4" height="7.5" rx="0.5" fill="currentColor"/><rect x="10.8" y="0" width="2.4" height="9.5" rx="0.5" fill="currentColor"/></svg>
          <svg width="24" height="11" viewBox="0 0 24 11"><rect x="0.5" y="0.5" width="20" height="10" rx="2.5" fill="none" stroke="currentColor"/><rect x="2" y="2" width="14" height="7" rx="1.2" fill="currentColor"/><rect x="21" y="3.5" width="2" height="4" rx="0.6" fill="currentColor"/></svg>
        </span>
      </div>

      {/* Content */}
      <div style={{ flex: 1, overflowY: 'auto' }}>
        {renderTabContent()}
      </div>

      {/* Bottom nav */}
      <div className="gz-bottomnav" style={{ flexShrink: 0 }}>
        {tabs.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            data-active={activeTab === tab.id}
          >
            {React.cloneElement(tab.icon, { style: { width: 22, height: 22 } })}
          </button>
        ))}
      </div>

      {/* Demo controls panel */}
      <div style={{
        position: 'fixed',
        bottom: 80,
        right: 12,
        background: 'var(--gz-card)',
        border: '1px solid var(--gz-rule)',
        borderRadius: 12,
        padding: 12,
        zIndex: 100,
        fontSize: 11,
        fontWeight: 600,
        maxWidth: 140,
        boxShadow: '0 4px 12px rgba(0,0,0,0.1)'
      }}>
        <div style={{ marginBottom: 8, color: 'var(--gz-fg-3)', textTransform: 'uppercase', fontSize: 9, letterSpacing: '0.08em' }}>Demo controls</div>
        <button
          onClick={() => setSessionActive(!sessionActive)}
          style={{
            width: '100%',
            padding: '6px 8px',
            background: sessionActive ? 'var(--gz-fg)' : 'var(--gz-card-tint)',
            color: sessionActive ? 'var(--gz-bg)' : 'var(--gz-fg)',
            border: 'none',
            borderRadius: 6,
            fontSize: 9,
            fontWeight: 600,
            cursor: 'pointer',
            marginBottom: 6
          }}
        >
          Session: {sessionActive ? 'ON' : 'OFF'}
        </button>
        <button
          onClick={() => setNotificationCount(notificationCount > 0 ? 0 : 3)}
          style={{
            width: '100%',
            padding: '6px 8px',
            background: notificationCount > 0 ? '#F2DAD5' : 'var(--gz-card-tint)',
            color: 'var(--gz-fg)',
            border: 'none',
            borderRadius: 6,
            fontSize: 9,
            fontWeight: 600,
            cursor: 'pointer',
            marginBottom: 6
          }}
        >
          Notif: {notificationCount > 0 ? notificationCount : '0'}
        </button>
        <button
          style={{
            width: '100%',
            padding: '6px 8px',
            background: 'var(--gz-pill-bg)',
            color: 'var(--gz-fg)',
            border: 'none',
            borderRadius: 6,
            fontSize: 9,
            fontWeight: 600,
            cursor: 'pointer'
          }}
        >
          Reset tabs
        </button>
      </div>

      {/* Notification sheet overlay */}
      {showNotificationSheet && (
        <div style={{
          position: 'fixed',
          inset: 0,
          background: 'rgba(0,0,0,0.5)',
          zIndex: 200,
          display: 'flex',
          alignItems: 'flex-end',
          animation: 'slideUpSheet 0.3s ease-out'
        }}>
          <div style={{
            width: '100%',
            background: 'var(--gz-card)',
            borderTopLeftRadius: 16,
            borderTopRightRadius: 16,
            padding: '12px 16px 20px',
            maxHeight: '60%',
            overflowY: 'auto'
          }}>
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 12 }}>
              <div style={{ width: 36, height: 4, background: 'var(--gz-rule)', borderRadius: 2 }} />
            </div>
            <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--gz-fg)', marginBottom: 12 }}>
              Notifications
            </div>
            {[...Array(notificationCount)].map((_, i) => (
              <div key={i} style={{
                padding: '12px',
                background: 'var(--gz-pill-bg)',
                borderRadius: 8,
                marginBottom: 8,
                fontSize: 12
              }}>
                <div style={{ fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 2 }}>Notification {i + 1}</div>
                <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>You have an update</div>
              </div>
            ))}
            <button
              onClick={() => setShowNotificationSheet(false)}
              style={{
                width: '100%',
                padding: '8px',
                background: 'none',
                border: 'none',
                color: 'var(--gz-fg-2)',
                fontSize: 12,
                cursor: 'pointer',
                marginTop: 12,
                fontWeight: 500
              }}
            >
              Close
            </button>
          </div>
        </div>
      )}

      <style>{`
        @keyframes slideUpSheet {
          from { transform: translateY(100%); }
          to { transform: translateY(0); }
        }
      `}</style>
    </div>
  );
}

Object.assign(window, { FullAppFlowDemo });
