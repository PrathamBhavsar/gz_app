// Screen 19 — Store Search Screen
// Focused search with filters. Speed matters — results appear as you type.

function StoreSearchScreen() {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFilters, setSelectedFilters] = useState(['All']);
  const [recentSearches] = useState([
    'GameZone Koramangala',
    'VR gaming bangalore',
    'PS5 near me',
  ]);

  const storeData = [
    { id: 1, name: 'GameZone Koramangala', addr: 'Koramangala 5th Block', dist: '1.2km', rating: 4.7, systems: ['PC', 'PS5', 'VR'], open: true },
    { id: 2, name: 'GameZone MG Road', addr: 'Brigade Road', dist: '2.8km', rating: 4.5, systems: ['PC', 'PS5'], open: true },
    { id: 3, name: 'GameZone Whitefield', addr: 'ITPL Main Road', dist: '6.1km', rating: 4.3, systems: ['PC', 'VR'], open: false, openTime: '10AM' },
    { id: 4, name: 'GameArena Indiranagar', addr: '100ft Road', dist: '3.4km', rating: 4.1, systems: ['PC', 'PS5', 'Xbox'], open: true },
    { id: 5, name: 'CyberZone HSR', addr: '27th Main', dist: '4.7km', rating: 3.9, systems: ['PC', 'Xbox'], open: true },
  ];

  const filters = ['All', 'PC Gaming', 'PS5', 'VR', 'Xbox', 'Open Now', 'Near Me'];

  const systemIcons = {
    'PC': I.pc,
    'PS5': I.ps,
    'VR': I.vr,
    'Xbox': I.xbox,
  };

  const toggleFilter = (f) => {
    if (f === 'All') {
      setSelectedFilters(['All']);
    } else {
      const newFilters = selectedFilters.filter(x => x !== 'All');
      if (newFilters.includes(f)) {
        setSelectedFilters(newFilters.filter(x => x !== f));
      } else {
        newFilters.push(f);
      }
      setSelectedFilters(newFilters.length > 0 ? newFilters : ['All']);
    }
  };

  const isFiltered = !selectedFilters.includes('All');
  const filteredStores = isFiltered
    ? storeData.filter(s => selectedFilters.some(f => s.systems?.includes(f)))
    : storeData;

  const showResults = searchQuery.length > 0;
  const noResults = showResults && filteredStores.length === 0;

  return (
    <Phone>
      <div style={{ padding: '8px 16px 12px', flexShrink: 0, display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{
          flex: 1,
          display: 'flex', alignItems: 'center', gap: 8,
          padding: '12px 14px', background: 'var(--gz-card)',
          borderRadius: 14, border: '1px solid var(--gz-rule)',
        }}>
          <span style={{ color: 'var(--gz-fg-3)' }}>
            {React.cloneElement(I.search, { style: { width: 18, height: 18 } })}
          </span>
          <input
            type="text"
            autoFocus
            placeholder="Search gaming stores..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            style={{
              flex: 1, background: 'transparent', border: 0, outline: 'none',
              fontSize: 14, fontFamily: 'var(--gz-font)',
              color: 'var(--gz-fg)',
            }}
          />
        </div>
        <button
          onClick={() => setSearchQuery('')}
          style={{
            background: 'transparent', border: 0, color: 'var(--gz-fg-3)',
            fontSize: 14, fontWeight: 600, cursor: 'pointer', padding: '8px 0',
          }}>
          Cancel
        </button>
      </div>

      {/* Filter chips */}
      <div className="gz-hscroll" style={{ flexShrink: 0 }}>
        {filters.map(f => {
          const isActive = selectedFilters.includes(f) || (f === 'All' && selectedFilters.includes('All'));
          return (
            <button
              key={f}
              onClick={() => toggleFilter(f)}
              style={{
                padding: '8px 14px',
                background: isActive ? 'var(--gz-btn)' : 'var(--gz-card)',
                color: isActive ? 'var(--gz-btn-fg)' : 'var(--gz-fg)',
                border: isActive ? 0 : `1px solid var(--gz-rule)`,
                borderRadius: 999, fontSize: 13, fontWeight: 600,
                cursor: 'pointer', whiteSpace: 'nowrap',
                transition: 'all 0.15s',
                flexShrink: 0,
              }}>
              {f}
            </button>
          );
        })}
      </div>

      <Scroll pad={false}>
        <div style={{ padding: '16px 16px 20px' }}>
          {!showResults && (
            <div>
              <div className="gz-h3" style={{ marginBottom: 12, color: 'var(--gz-fg)' }}>Recent searches</div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {recentSearches.map((s, i) => (
                  <div
                    key={i}
                    style={{
                      display: 'flex', alignItems: 'center', gap: 10,
                      padding: '12px 0', borderBottom: `1px solid var(--gz-rule)`,
                      color: 'var(--gz-fg)', textAlign: 'left',
                    }}>
                    <button
                      onClick={() => setSearchQuery(s)}
                      style={{
                        flex: 1,
                        display: 'flex', alignItems: 'center', gap: 10,
                        background: 'transparent', border: 0, cursor: 'pointer',
                        color: 'var(--gz-fg)', textAlign: 'left', padding: 0,
                      }}>
                      <span style={{ color: 'var(--gz-fg-3)', flexShrink: 0 }}>
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7">
                          <circle cx="12" cy="12" r="10"/>
                          <path d="M12 7v5l3 2"/>
                        </svg>
                      </span>
                      <span className="gz-body" style={{ fontWeight: 500 }}>{s}</span>
                    </button>
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        // Remove search
                      }}
                      style={{
                        background: 'transparent', border: 0, cursor: 'pointer',
                        color: 'var(--gz-fg-3)', padding: 4, flexShrink: 0,
                      }}>
                      {React.cloneElement(I.x, { style: { width: 16, height: 16 } })}
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}

          {noResults && (
            <div style={{ textAlign: 'center', paddingTop: 60 }}>
              <div className="gz-h2" style={{ marginBottom: 8, color: 'var(--gz-fg-2)' }}>No stores found</div>
              <div className="gz-body-r" style={{ marginBottom: 20 }}>
                for '{searchQuery}'
              </div>
              <button style={{
                padding: '12px 16px',
                background: 'transparent', border: 0,
                color: 'var(--gz-info)', fontSize: 14, fontWeight: 600,
                cursor: 'pointer',
              }}>Try a different search or browse all stores →</button>
            </div>
          )}

          {showResults && filteredStores.length > 0 && (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              {filteredStores.map(store => {
                const hasNoVR = isFiltered && selectedFilters.includes('VR') && !store.systems.includes('VR');
                return (
                  <button
                    key={store.id}
                    style={{
                      background: hasNoVR ? 'var(--gz-pill-bg)' : 'var(--gz-card)',
                      border: `1px solid var(--gz-rule)`,
                      borderRadius: 16, padding: 16,
                      textAlign: 'left', cursor: 'pointer',
                      opacity: hasNoVR ? 0.6 : 1,
                      transition: 'all 0.15s',
                    }}>
                    <div style={{ display: 'flex', gap: 12, marginBottom: 10 }}>
                      {/* Store image placeholder */}
                      <div style={{
                        width: 56, height: 56, borderRadius: 10,
                        background: `linear-gradient(135deg, var(--gz-card-tint-strong) 0%, var(--gz-card-tint) 100%)`,
                        flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
                        color: 'var(--gz-fg)', fontSize: 10, fontWeight: 600,
                      }}>STORE</div>

                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div className="gz-body" style={{ fontWeight: 600, marginBottom: 4 }}>{store.name}</div>
                        <div className="gz-small" style={{ color: 'var(--gz-fg-2)', marginBottom: 2 }}>{store.addr}</div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                          <span className="gz-small" style={{ color: 'var(--gz-fg-2)' }}>★{store.rating}</span>
                          <span className="gz-tag gz-tag--mute" style={{ fontSize: 11 }}>
                            {store.open ? 'Open now' : `Opens ${store.openTime}`}
                          </span>
                        </div>
                      </div>

                      <div style={{ textAlign: 'right', flexShrink: 0 }}>
                        <div className="gz-body" style={{ fontWeight: 600, color: 'var(--gz-fg-2)' }}>{store.dist}</div>
                      </div>
                    </div>

                    {/* Systems chips */}
                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                      {store.systems.map(sys => (
                        <span
                          key={sys}
                          style={{
                            display: 'inline-flex', alignItems: 'center', gap: 4,
                            padding: '6px 10px', background: 'var(--gz-pill-bg)', borderRadius: 999,
                            fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)',
                          }}>
                          {React.cloneElement(systemIcons[sys], { style: { width: 14, height: 14 } })}
                          {sys}
                        </span>
                      ))}
                      {hasNoVR && (
                        <span style={{
                          display: 'inline-flex', alignItems: 'center',
                          padding: '6px 10px', fontSize: 12, fontWeight: 600,
                          color: 'var(--gz-fg-3)',
                        }}>No VR systems</span>
                      )}
                    </div>
                  </button>
                );
              })}
            </div>
          )}
        </div>
      </Scroll>
    </Phone>
  );
}

Object.assign(window, { StoreSearchScreen });
