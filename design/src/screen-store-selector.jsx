function StoreSelectorSheet() {
  const [searchQuery, setSearchQuery] = React.useState('');
  const [nearMe, setNearMe] = React.useState(false);
  const [activeStoreId, setActiveStoreId] = React.useState('koramangala');
  const [showToast, setShowToast] = React.useState(null);

  const allStores = [
    { id: 'koramangala', name: 'GameZone Koramangala', distance: 1.2, status: 'Open now', statusType: 'open' },
    { id: 'mgroad', name: 'GameZone MG Road', distance: 2.8, status: 'Open now', statusType: 'open' },
    { id: 'whitefield', name: 'GameZone Whitefield', distance: 6.1, status: 'Opens 10AM', statusType: 'closed' },
    { id: 'indiranagar', name: 'GameArena Indiranagar', distance: 3.4, status: 'Open now', statusType: 'open' },
    { id: 'cyberzone', name: 'CyberZone HSR', distance: 4.7, status: 'Open now', statusType: 'open' },
    { id: 'ecity', name: 'GameZone Electronic City', distance: 8.2, status: 'Open now', statusType: 'open' },
    { id: 'hebbal', name: 'GameZone Hebbal', distance: 11.4, status: 'Closed — Opens 10AM tomorrow', statusType: 'closed' },
  ];

  const recentStores = allStores.slice(0, 3);

  const sorted = nearMe ? [...allStores].sort((a, b) => a.distance - b.distance) : allStores;
  const filtered = sorted.filter(s => s.name.toLowerCase().includes(searchQuery.toLowerCase()));

  const StoreRow = ({ store, isRecent, storeIndex }) => (
    <button
      onClick={() => {
        if (store.statusType === 'closed') {
          setShowToast('This store is currently closed — you can still browse');
        } else {
          setActiveStoreId(store.id);
        }
      }}
      style={{
        width: '100%',
        padding: '12px 16px',
        background: activeStoreId === store.id ? 'var(--gz-pill-bg)' : 'transparent',
        border: 'none',
        borderRadius: 8,
        cursor: 'pointer',
        display: 'flex',
        alignItems: 'center',
        gap: 12,
        marginBottom: 8,
        opacity: store.statusType === 'closed' ? 0.6 : 1
      }}
    >
      {/* Store initial circle - Walle-inspired colors */}
      <Avatar size="lg" index={storeIndex}>{store.name[0]}</Avatar>

      {/* Store info */}
      <div style={{ flex: 1, textAlign: 'left', minWidth: 0 }}>
        <div style={{ fontSize: 14, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 2 }}>
          {store.name}
        </div>
        <div style={{ fontSize: 11, color: 'var(--gz-fg-2)' }}>
          {store.distance} km
        </div>
      </div>

      {/* Status pill */}
      <div style={{
        padding: '4px 8px',
        borderRadius: 4,
        fontSize: 10,
        fontWeight: 600,
        background: store.statusType === 'open' ? 'var(--gz-ok-bg)' : 'var(--gz-warn-bg)',
        color: store.statusType === 'open' ? 'var(--gz-ok)' : 'var(--gz-warn)',
        whiteSpace: 'nowrap',
        flexShrink: 0
      }}>
        {store.status}
      </div>

      {/* Checkmark */}
      {activeStoreId === store.id && (
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--gz-fg)', flexShrink: 0 }}>
          {React.cloneElement(I.check, { style: { width: 18, height: 18 } })}
        </div>
      )}
    </button>
  );

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: 'rgba(0,0,0,0.5)', position: 'relative' }}>
      {/* Dimmed background */}
      <div style={{ flex: 1 }} />

      {/* Bottom sheet */}
      <div style={{
        background: 'var(--gz-card)',
        borderTopLeftRadius: 24,
        borderTopRightRadius: 24,
        display: 'flex',
        flexDirection: 'column',
        maxHeight: '75%',
        padding: '16px 16px',
        boxSizing: 'border-box'
      }}>
        {/* Handle bar */}
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 12 }}>
          <div style={{ width: 40, height: 4, background: 'var(--gz-rule)', borderRadius: 2 }} />
        </div>

        {/* Header */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
          <div style={{ fontSize: 18, fontWeight: 700, color: 'var(--gz-fg)' }}>
            Select a store
          </div>
          <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
            <button
              onClick={() => setNearMe(!nearMe)}
              style={{
                background: 'none',
                border: 'none',
                cursor: 'pointer',
                color: nearMe ? 'var(--gz-fg)' : 'var(--gz-fg-3)',
                padding: 0,
                width: 38,
                height: 38,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
              title="Near me"
            >
              {React.cloneElement(I.pin, { style: { width: 20, height: 20 } })}
            </button>
            <button style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', justifyContent: 'center', width: 38, height: 38 }}>
              {React.cloneElement(I.x, { style: { width: 20, height: 20 } })}
            </button>
          </div>
        </div>

        {/* Search bar */}
        <div style={{
          display: 'flex',
          alignItems: 'center',
          background: 'var(--gz-card)',
          border: '1px solid var(--gz-rule)',
          borderRadius: 8,
          paddingLeft: 12,
          paddingRight: 12,
          height: 40,
          marginBottom: 16
        }}>
          <input
            autoFocus
            type="text"
            placeholder="Search stores..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            style={{
              flex: 1,
              border: 'none',
              background: 'none',
              fontSize: 13,
              color: 'var(--gz-fg)',
              outline: 'none'
            }}
          />
          {searchQuery && (
            <button style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--gz-fg-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }} onClick={() => setSearchQuery('')}>
              {React.cloneElement(I.x, { style: { width: 16, height: 16 } })}
            </button>
          )}
        </div>

        {/* Scrollable content */}
        <div style={{ flex: 1, overflowY: 'auto', paddingRight: 4 }}>
          {!searchQuery && (
            <>
              {/* Recently visited */}
              <div style={{ marginBottom: 20 }}>
                <div style={{ fontSize: 11, fontWeight: 700, textTransform: 'uppercase', color: 'var(--gz-fg-3)', marginBottom: 8, letterSpacing: '0.12em' }}>
                  Recently visited
                </div>
                {recentStores.map((store, idx) => (
                  <StoreRow key={store.id} store={store} isRecent={true} storeIndex={idx} />
                ))}
              </div>

              <div style={{ height: 1, background: 'var(--gz-rule)', marginBottom: 16 }} />
            </>
          )}

          {/* All stores or filtered */}
          <div>
            <div style={{ fontSize: 11, fontWeight: 700, textTransform: 'uppercase', color: 'var(--gz-fg-3)', marginBottom: 8, letterSpacing: '0.12em' }}>
              {searchQuery ? 'Results' : 'All stores'}
            </div>
            {filtered.map((store, idx) => (
              <StoreRow key={store.id} store={store} isRecent={false} storeIndex={idx} />
            ))}
            {filtered.length === 0 && (
              <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', padding: '16px', textAlign: 'center' }}>
                No stores found
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Toast notification */}
      {showToast && (
        <div style={{
          position: 'fixed',
          bottom: '80px',
          left: '16px',
          right: '16px',
          background: 'var(--gz-fg)',
          color: 'var(--gz-bg)',
          padding: '12px 16px',
          borderRadius: 8,
          fontSize: 12,
          fontWeight: 600,
          zIndex: 1000,
          animation: 'slideUp 0.3s ease-out'
        }}>
          {showToast}
        </div>
      )}

      <style>{`
        @keyframes slideUp {
          from { transform: translateY(100px); opacity: 0; }
          to { transform: translateY(0); opacity: 1; }
        }
      `}</style>
    </div>
  );
}

Object.assign(window, { StoreSelectorSheet });
