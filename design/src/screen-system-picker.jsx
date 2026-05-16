// Screen 28 — System Picker
// Step 3 of booking flow. Player picks the exact seat/system for their selected time slot.

function SystemPickerScreen() {
  const [sortBy, setSortBy] = useState('recommended'); // 'recommended' | 'price-asc' | 'price-desc' | 'availability'
  const [selectedSystem, setSelectedSystem] = useState(null);

  const allSystems = [
    {
      id: 1, name: 'RTX 4090 Gaming PC', specs: 'RTX 4090 · 32GB RAM · 240Hz · 4K',
      seat: 'Seat 3', price: 80, status: 'available', recommended: true,
    },
    {
      id: 2, name: 'RTX 3080 Gaming PC', specs: 'RTX 3080 · 16GB RAM · 165Hz · 1440p',
      seat: 'Seat 7', price: 70, status: 'available',
    },
    {
      id: 3, name: 'RTX 3070 Gaming PC', specs: 'RTX 3070 · 16GB RAM · 144Hz · 1440p',
      seat: 'Seat 1', price: 60, status: 'in-use', availableAt: '5:30 PM',
    },
    {
      id: 4, name: 'RTX 3060 Gaming PC', specs: 'RTX 3060 · 12GB RAM · 120Hz · 1440p',
      seat: 'Seat 9', price: 55, status: 'available',
    },
    {
      id: 5, name: 'i9 High Performance PC', specs: 'i9-13900K · 32GB RAM · 360Hz · 4K',
      seat: 'Seat 2', price: 90, status: 'unavailable',
    },
  ];

  let sortedSystems = [...allSystems];
  if (sortBy === 'price-asc') {
    sortedSystems.sort((a, b) => a.price - b.price);
  } else if (sortBy === 'price-desc') {
    sortedSystems.sort((a, b) => b.price - a.price);
  } else if (sortBy === 'availability') {
    sortedSystems.sort((a, b) => {
      const statusOrder = { available: 0, 'in-use': 1, unavailable: 2 };
      return (statusOrder[a.status] || 3) - (statusOrder[b.status] || 3);
    });
  } else if (sortBy === 'recommended') {
    sortedSystems.sort((a, b) => {
      if (a.recommended) return -1;
      if (b.recommended) return 1;
      return 0;
    });
  }

  const getSortLabel = () => {
    switch(sortBy) {
      case 'price-asc': return 'Price ↑';
      case 'price-desc': return 'Price ↓';
      case 'availability': return 'Availability';
      case 'recommended': return 'Recommended';
      default: return 'Sort by';
    }
  };

  const cycleSortBy = () => {
    const cycle = ['recommended', 'price-asc', 'price-desc', 'availability'];
    const idx = cycle.indexOf(sortBy);
    setSortBy(cycle[(idx + 1) % cycle.length]);
  };

  const getStatusBgColor = (status) => {
    switch(status) {
      case 'available': return 'var(--gz-ok-bg)';
      case 'in-use': return 'var(--gz-warn-bg)';
      case 'unavailable': return 'var(--gz-err-bg)';
      default: return 'var(--gz-pill-bg)';
    }
  };

  const getStatusTextColor = (status) => {
    switch(status) {
      case 'available': return 'var(--gz-ok)';
      case 'in-use': return 'var(--gz-warn)';
      case 'unavailable': return 'var(--gz-err)';
      default: return 'var(--gz-fg-2)';
    }
  };

  return (
    <Phone>
      <TopBar
        title="Pick your system"
        onBack={() => {}}
      />

      <Scroll>
        {/* store context banner */}
        <div style={{
          background: 'var(--gz-card)',
          borderRadius: 14,
          padding: 12,
          marginBottom: 16,
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        }}>
          <div>
            <div className="gz-meta" style={{ marginBottom: 4, color: 'var(--gz-fg-3)' }}>BOOKING AT</div>
            <div className="gz-body" style={{ fontWeight: 600 }}>GameZone Koramangala</div>
          </div>
          <button style={{
            background: 'transparent', border: 0,
            fontSize: 12, fontWeight: 600,
            color: 'var(--gz-fg)',
            textDecoration: 'underline',
            padding: 0,
          }}>
            Change
          </button>
        </div>

        {/* slot recap */}
        <div style={{
          display: 'flex', flexDirection: 'column', gap: 10,
          marginBottom: 16,
        }}>
          <div style={{
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            padding: '10px 12px',
            background: 'var(--gz-pill-bg)',
            borderRadius: 999,
          }}>
            <span className="gz-body" style={{ fontWeight: 600 }}>
              Tomorrow · 4:00 PM – 6:00 PM · 2 hrs
            </span>
            <button style={{
              background: 'transparent', border: 0,
              fontSize: 12, fontWeight: 600,
              color: 'var(--gz-fg)',
              textDecoration: 'underline',
              padding: 0,
            }}>
              Change
            </button>
          </div>
          <div style={{
            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
            padding: '10px 12px',
            background: 'var(--gz-pill-bg)',
            borderRadius: 999,
          }}>
            <span className="gz-body" style={{ fontWeight: 600 }}>PC Gaming</span>
            <button style={{
              background: 'transparent', border: 0,
              fontSize: 12, fontWeight: 600,
              color: 'var(--gz-fg)',
              textDecoration: 'underline',
              padding: 0,
            }}>
              Change type
            </button>
          </div>
        </div>

        {/* availability info */}
        <div className="gz-small" style={{ color: 'var(--gz-fg-2)', marginBottom: 14 }}>
          8 of 12 PC systems available for your slot
        </div>

        {/* sort bar */}
        <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <button onClick={cycleSortBy}
            style={{
              padding: '8px 14px',
              background: 'var(--gz-pill-bg)',
              border: 0, borderRadius: 999,
              fontSize: 13, fontWeight: 600,
              color: 'var(--gz-fg)',
              cursor: 'pointer',
              display: 'inline-flex', alignItems: 'center', gap: 6,
            }}>
            Sort by: {getSortLabel()}
          </button>
        </div>

        {/* systems list */}
        {sortedSystems.map((sys, i) => (
          <div key={sys.id}
            onClick={() => sys.status === 'available' && setSelectedSystem(sys.id)}
            style={{
              width: '100%',
              background: 'var(--gz-card)',
              border: 0, borderRadius: 18,
              padding: '16px',
              marginBottom: 12,
              textAlign: 'left',
              opacity: sys.status === 'unavailable' ? 0.5 : 1,
              cursor: sys.status === 'available' ? 'pointer' : 'default',
            }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 8 }}>
              <div style={{ flex: 1 }}>
                <div className="gz-h3" style={{ marginBottom: 4 }}>{sys.name}</div>
                <div className="gz-small" style={{ color: 'var(--gz-fg-2)', marginBottom: 8 }}>
                  {sys.specs}
                </div>
              </div>
              {sys.recommended && (
                <span className="gz-tag" style={{
                  background: 'var(--gz-purple-bg)',
                  color: 'var(--gz-purple)',
                  marginLeft: 8, flexShrink: 0,
                }}>
                  Recommended
                </span>
              )}
            </div>

            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 10 }}>
              <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
                <span className="gz-chip" style={{ flexShrink: 0 }}>{sys.seat}</span>
                <span className="gz-body" style={{ fontWeight: 600, color: 'var(--gz-fg)' }}>
                  ₹{sys.price}/hr
                </span>
              </div>
              {sys.status === 'available' && (
                <span className="gz-tag" style={{
                  background: 'var(--gz-ok-bg)',
                  color: 'var(--gz-ok)',
                }}>
                  Available ✓
                </span>
              )}
              {sys.status === 'in-use' && (
                <span className="gz-tag" style={{
                  background: 'var(--gz-warn-bg)',
                  color: 'var(--gz-warn)',
                }}>
                  In use
                </span>
              )}
              {sys.status === 'unavailable' && (
                <span className="gz-tag" style={{
                  background: 'var(--gz-err-bg)',
                  color: 'var(--gz-err)',
                }}>
                  Unavailable
                </span>
              )}
            </div>

            {sys.status === 'in-use' && (
              <div className="gz-small" style={{ color: 'var(--gz-warn)' }}>
                Free at {sys.availableAt} — change your slot?
              </div>
            )}

            {sys.status === 'available' && (
              <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
                <button onClick={e => { e.stopPropagation(); setSelectedSystem(sys.id); }}
                  style={{
                    background: 'var(--gz-btn)',
                    color: '#fff',
                    border: 0, borderRadius: 10,
                    padding: '8px 14px',
                    fontSize: 12, fontWeight: 600,
                    cursor: 'pointer',
                    display: 'inline-flex', alignItems: 'center', gap: 6,
                  }}>
                  Choose this seat {React.cloneElement(I.chev, { style: { width: 14, height: 14 } })}
                </button>
              </div>
            )}
          </div>
        ))}
      </Scroll>

      <BottomNav active="book" />
    </Phone>
  );
}

Object.assign(window, { SystemPickerScreen });
