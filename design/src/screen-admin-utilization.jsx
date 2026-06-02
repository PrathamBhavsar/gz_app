// Screen: Admin Utilization Heatmap
function AdminUtilizationScreen() {
  const viewFilters = ['Day', 'Week'];
  const hours = ['10','11','12','1','2','3','4','5','6','7','8','9','10','11'];
  const systems = Array.from({ length: 12 }, (_, i) => i);

  // Generate realistic heatmap data — morning low, afternoon medium, evening peak
  const getIntensity = (sysIdx, hourIdx) => {
    const base = [0.1, 0.15, 0.25, 0.35, 0.4, 0.45, 0.5, 0.6, 0.75, 0.9, 0.85, 0.7, 0.5, 0.3];
    const noise = ((sysIdx * 7 + hourIdx * 13) % 11) / 30;
    return Math.min(1, Math.max(0, (base[hourIdx] || 0.3) + noise - 0.15));
  };

  const intensityToColor = (v) => {
    if (v < 0.15) return 'var(--gz-card)';
    if (v < 0.4) return 'var(--gz-card-tint)';
    if (v < 0.65) return 'var(--gz-card-tint-strong)';
    if (v < 0.85) return '#7BA87B';
    return 'var(--gz-btn)';
  };

  return (
    <Phone>
      <AdminTopBar title="Utilization" onBack={() => {}} />

      {/* View mode chips */}
      <div style={{ display: 'flex', gap: 8, padding: '0 16px 10px', flexShrink: 0 }}>
        {viewFilters.map((f, i) => (
          <AdminChip key={f} label={f} active={i === 0} />
        ))}
      </div>

      <Scroll pad={false}>
        <div style={{ padding: '0 16px 24px' }}>
          <div style={{ height: 12 }} />

          {/* Peak hours card */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3">Peak hour: 7 PM – 9 PM</div>
            <div style={{ height: 4 }} />
            <div className="gz-small" style={{ color: 'var(--gz-ok)' }}>89% average occupancy</div>
          </div>

          <div style={{ height: 12 }} />

          {/* Heatmap grid */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <div className="gz-h3" style={{ marginBottom: 14 }}>Hourly occupancy</div>

            {/* Hour labels */}
            <div style={{ display: 'flex', gap: 2, marginBottom: 4, paddingLeft: 4 }}>
              {hours.map((h, i) => (
                <div key={i} style={{ width: 18, textAlign: 'center', flexShrink: 0 }}>
                  <span className="gz-meta" style={{ fontSize: 8, letterSpacing: 0 }}>{h}</span>
                </div>
              ))}
            </div>

            {/* Grid rows */}
            {systems.map((s) => (
              <div key={s} style={{ display: 'flex', gap: 2, marginBottom: 2 }}>
                {hours.map((_, hi) => (
                  <div key={hi} style={{
                    width: 18, height: 18, borderRadius: 3, flexShrink: 0,
                    background: intensityToColor(getIntensity(s, hi)),
                  }} />
                ))}
              </div>
            ))}

            {/* Legend */}
            <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 8 }}>
              <span className="gz-small" style={{ fontSize: 10 }}>0%</span>
              {['var(--gz-card)', 'var(--gz-card-tint)', 'var(--gz-card-tint-strong)', 'var(--gz-btn)'].map((c, i) => (
                <div key={i} style={{
                  width: 14, height: 14, borderRadius: 2, background: c,
                  border: c === 'var(--gz-card)' ? '1px solid var(--gz-rule)' : 'none',
                }} />
              ))}
              <span className="gz-small" style={{ fontSize: 10 }}>100%</span>
            </div>
          </div>

          <div style={{ height: 12 }} />

          {/* Summary stats */}
          <div className="gz-card" style={{ padding: 16, borderRadius: 16 }}>
            <MetaRow label="Avg occupancy" value="67%" />
            <MetaRow label="Peak time" value="7:00 PM" />
            <MetaRow label="Quietest" value="11:00 AM" />
          </div>
        </div>
      </Scroll>
    </Phone>
  );
}
Object.assign(window, { AdminUtilizationScreen });
