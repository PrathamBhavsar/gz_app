// GZ shared components — building blocks the 4 screens compose.
// All consume the .gz design tokens from src/tokens.css.

const { useState, useEffect, useRef, useMemo } = React;

// ───────── icons (single source) ─────────
const I = {
  back:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M15 5l-7 7 7 7"/></svg>,
  chev:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M9 5l7 7-7 7"/></svg>,
  chevDn: <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 9l7 7 7-7"/></svg>,
  chevUp: <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 15l7-7 7 7"/></svg>,
  search: <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="11" cy="11" r="6.5"/><path d="M20 20l-3.5-3.5"/></svg>,
  bell:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M18 16H6l1.5-2V11a4.5 4.5 0 019 0v3L18 16z"/><path d="M10.5 19a1.5 1.5 0 003 0"/></svg>,
  star:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 4l2.5 5 5.5.8-4 3.9.9 5.5L12 16.7l-4.9 2.5.9-5.5-4-3.9L9.5 9 12 4z"/></svg>,
  filter: <svg viewBox="0 0 24 24" className="gz-ic"><path d="M4 6h16M7 12h10M10 18h4"/></svg>,
  pc:     <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="4" width="18" height="11" rx="1.5"/><path d="M9 19h6M12 15v4"/></svg>,
  ps:     <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 14c0-3 2-5 4-5h6c2 0 4 2 4 5"/><circle cx="8.5" cy="14" r="1.5"/><circle cx="15.5" cy="14" r="1.5"/><path d="M3 18h18"/></svg>,
  vr:     <svg viewBox="0 0 24 24" className="gz-ic"><rect x="2.5" y="7" width="19" height="10" rx="3"/><circle cx="8" cy="12" r="1.6"/><circle cx="16" cy="12" r="1.6"/></svg>,
  xbox:   <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="12" cy="12" r="9"/><path d="M5 5c3 1 5 3 7 7M19 5c-3 1-5 3-7 7M5 19c3-2 5-5 7-7M19 19c-3-2-5-5-7-7"/></svg>,
  seat:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M7 11V6a2 2 0 012-2h6a2 2 0 012 2v5M5 11h14v6H5z"/><path d="M7 17v3M17 17v3"/></svg>,
  clock:  <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="12" cy="12" r="8.5"/><path d="M12 7v5l3 2"/></svg>,
  cal:    <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3.5" y="5" width="17" height="15" rx="2"/><path d="M3.5 10h17M8 3v4M16 3v4"/></svg>,
  list:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 7h14M5 12h14M5 17h9"/></svg>,
  chat:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M4 6a2 2 0 012-2h12a2 2 0 012 2v8a2 2 0 01-2 2H10l-4 4v-4H6a2 2 0 01-2-2V6z"/></svg>,
  sos:    <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 3l9 16H3l9-16z"/><path d="M12 10v4M12 17v.5"/></svg>,
  cash:   <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="6" width="18" height="12" rx="2"/><circle cx="12" cy="12" r="2.5"/></svg>,
  upi:    <svg viewBox="0 0 24 24" className="gz-ic"><path d="M9 5l-4 7h5l-3 7 9-10h-5l3-4H9z" fill="currentColor" stroke="none"/></svg>,
  card:   <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="6" width="18" height="12" rx="2"/><path d="M3 10h18"/></svg>,
  coin:   <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="12" cy="12" r="8.5"/><path d="M12 7v10M9.5 9.5h4a1.8 1.8 0 010 3.5h-4M9.5 13h4a1.8 1.8 0 010 3.5h-4"/></svg>,
  gift:   <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="9" width="18" height="11" rx="1.5"/><path d="M3 13h18M12 9v11M8 9a2 2 0 010-4c1.5 0 2.5 1.5 4 4M16 9a2 2 0 000-4c-1.5 0-2.5 1.5-4 4"/></svg>,
  up:     <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 20V5M6 11l6-6 6 6"/></svg>,
  down:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 4v15M6 13l6 6 6-6"/></svg>,
  bin:    <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 7h14M9 7V5h6v2M7 7l1 12h8l1-12"/></svg>,
  info:   <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="12" cy="12" r="8.5"/><path d="M12 11v5M12 8v.5"/></svg>,
  staff:  <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="12" cy="8" r="3"/><path d="M5 20c1.5-4 4-6 7-6s5.5 2 7 6"/></svg>,
  plus:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 5v14M5 12h14"/></svg>,
  home:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M4 11l8-7 8 7v9a1 1 0 01-1 1h-4v-6h-6v6H5a1 1 0 01-1-1v-9z"/></svg>,
  book:   <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 4h11l3 3v13H5z"/><path d="M9 9h7M9 13h7M9 17h4"/></svg>,
  games:  <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="7" width="18" height="11" rx="3.5"/><path d="M8 12h3M9.5 10.5v3M15 11.5v.5M17 13v.5"/></svg>,
  wallet: <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="6" width="18" height="13" rx="2.5"/><path d="M3 10h18M16.5 14h2"/></svg>,
  user:   <svg viewBox="0 0 24 24" className="gz-ic"><circle cx="12" cy="8.5" r="3.5"/><path d="M5 20c1.2-4 4-6 7-6s5.8 2 7 6"/></svg>,
  phone:  <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 4h4l2 5-2.5 1.5a11 11 0 005 5L15 13l5 2v4a1 1 0 01-1 1A15 15 0 014 5a1 1 0 011-1z"/></svg>,
  pin:    <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 21s7-6 7-12a7 7 0 10-14 0c0 6 7 12 7 12z"/><circle cx="12" cy="9" r="2.5"/></svg>,
  nav:    <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 3l9 9-9 3-3-3-3 9z"/></svg>,
  check:  <svg viewBox="0 0 24 24" className="gz-ic"><path d="M5 12l5 5L20 7"/></svg>,
  pad:    <svg viewBox="0 0 24 24" className="gz-ic"><rect x="3" y="8" width="18" height="10" rx="4"/><path d="M8 13h3M9.5 11.5v3M15 12.5v.5M17 14v.5"/></svg>,
  scale:  <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 4v16M5 8h14M5 8l-2 6h4l-2-6zM19 8l-2 6h4l-2-6z"/></svg>,
  x:      <svg viewBox="0 0 24 24" className="gz-ic"><path d="M6 6l12 12M18 6L6 18"/></svg>,
  warnT:  <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 3l10 18H2L12 3z"/><path d="M12 10v5M12 18v.5"/></svg>,
  dl:     <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 4v12M6 11l6 6 6-6M4 20h16"/></svg>,
  spark:  <svg viewBox="0 0 24 24" className="gz-ic"><path d="M12 3v4M12 17v4M3 12h4M17 12h4M6 6l2.5 2.5M15.5 15.5L18 18M6 18l2.5-2.5M15.5 8.5L18 6"/></svg>,
};

// ───────── Phone shell — minimal, no notch (acts as "app container") ─────────
function Phone({ children, width = 390, height = 800 }) {
  return (
    <div className="gz" style={{
      width, height,
      background: 'var(--gz-bg)',
      overflow: 'hidden',
      position: 'relative',
      display: 'flex', flexDirection: 'column',
    }}>
      <StatusBar />
      {children}
    </div>
  );
}

function StatusBar() {
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      padding: '14px 24px 6px',
      fontFamily: 'var(--gz-font)', fontSize: 14, fontWeight: 600,
      color: 'var(--gz-fg)', flexShrink: 0,
    }}>
      <span>9:41</span>
      <span style={{ display: 'inline-flex', gap: 4, alignItems: 'center' }}>
        <svg width="16" height="10" viewBox="0 0 16 10"><rect x="0" y="6" width="2.4" height="3.5" rx="0.5" fill="currentColor"/><rect x="3.6" y="4" width="2.4" height="5.5" rx="0.5" fill="currentColor"/><rect x="7.2" y="2" width="2.4" height="7.5" rx="0.5" fill="currentColor"/><rect x="10.8" y="0" width="2.4" height="9.5" rx="0.5" fill="currentColor"/></svg>
        <svg width="24" height="11" viewBox="0 0 24 11"><rect x="0.5" y="0.5" width="20" height="10" rx="2.5" fill="none" stroke="currentColor"/><rect x="2" y="2" width="14" height="7" rx="1.2" fill="currentColor"/><rect x="21" y="3.5" width="2" height="4" rx="0.6" fill="currentColor"/></svg>
      </span>
    </div>
  );
}

// ───────── TopBar — back arrow + centered title + sub + trailing icon ─────────
function TopBar({ title, subtitle, onBack, trailing, disabledBack = false }) {
  return (
    <div style={{ padding: '8px 16px 12px', display: 'grid', gridTemplateColumns: '40px 1fr 40px', alignItems: 'center', flexShrink: 0 }}>
      <button onClick={onBack} disabled={disabledBack}
        style={{ width: 38, height: 38, border: 0, background: 'transparent',
          color: disabledBack ? 'var(--gz-fg-4)' : 'var(--gz-fg)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 0 }}>
        {I.back}
      </button>
      <div style={{ textAlign: 'center' }}>
        <div className="gz-h2">{title}</div>
        {subtitle && <div className="gz-small" style={{ marginTop: 2 }}>{subtitle}</div>}
      </div>
      <div style={{ display: 'flex', justifyContent: 'flex-end' }}>{trailing}</div>
    </div>
  );
}

// ───────── BottomNav (5 tabs) ─────────
function BottomNav({ active = 'home' }) {
  const tabs = [
    { id: 'home',   icon: I.home },
    { id: 'book',   icon: I.book },
    { id: 'games',  icon: I.games },
    { id: 'wallet', icon: I.wallet },
    { id: 'me',     icon: I.user },
  ];
  return (
    <div className="gz-bottomnav" style={{ flexShrink: 0 }}>
      {tabs.map(t => (
        <button key={t.id} data-active={active === t.id}>
          {React.cloneElement(t.icon, { style: { width: 22, height: 22 } })}
        </button>
      ))}
    </div>
  );
}

// ───────── Scrollable content area ─────────
function Scroll({ children, pad = true }) {
  return (
    <div style={{
      flex: 1, overflowY: 'auto', overflowX: 'hidden',
      padding: pad ? '4px 16px 24px' : 0,
      scrollbarWidth: 'none',
    }}>
      <style>{`.gz ::-webkit-scrollbar{display:none}`}</style>
      {children}
    </div>
  );
}

// ───────── small UI bits ─────────
function Tag({ kind = 'mute', children }) {
  return <span className={`gz-tag gz-tag--${kind}`}>{children}</span>;
}

function Chip({ k, v, active = false, onClick }) {
  return (
    <button onClick={onClick}
      className={`gz-chip ${active ? 'gz-chip--filled' : ''}`}
      style={{ border: 0, cursor: onClick ? 'pointer' : 'default' }}>
      {k && <span className="gz-chip__k">{k}</span>}{v}
    </button>
  );
}

function LiveDot() {
  return (
    <span style={{ display: 'inline-flex', alignItems: 'center', gap: 8 }}>
      <span className="gz-dot-pulse" />
    </span>
  );
}

function IconBtn({ children, onClick }) {
  return (
    <button onClick={onClick} style={{
      width: 38, height: 38, border: 0, background: 'transparent',
      color: 'var(--gz-fg)', borderRadius: 999,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', padding: 0,
    }}>{children}</button>
  );
}

// Row of metadata (label · value) used in cards
function MetaRow({ label, value, valueClass = '' }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', padding: '6px 0' }}>
      <span className="gz-body-r" style={{ color: 'var(--gz-fg-2)' }}>{label}</span>
      <span className={`gz-body gz-num ${valueClass}`}>{value}</span>
    </div>
  );
}

// Collapsible section
function Collapse({ title, open, onToggle, right, children }) {
  return (
    <div className="gz-card" style={{ padding: '4px 4px 4px' }}>
      <button onClick={onToggle}
        style={{ width: '100%', background: 'transparent', border: 0, padding: '16px 16px',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <span className="gz-h2">{title}</span>
        <span style={{ display: 'inline-flex', gap: 10, alignItems: 'center', color: 'var(--gz-fg-3)' }}>
          {right}
          <span style={{ transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .2s', display: 'inline-flex' }}>{I.chevDn}</span>
        </span>
      </button>
      {open && <div style={{ padding: '0 16px 16px' }}>{children}</div>}
    </div>
  );
}

// Avatar circle tile — colored circle with icon or letters (Walle-inspired design)
// Sizes: 'sm' (32px), 'md' (34px default), 'lg' (40px), 'xl' (56px)
// Colors: Walle-inspired soft, muted palette with subtle backgrounds
const AVATAR_COLORS = [
  { bg: '#EAD5C8', fg: '#5C4A40' }, // soft peachy beige
  { bg: '#D4E4D8', fg: '#3D5A45' }, // soft sage green
  { bg: '#DFD4E8', fg: '#534968' }, // soft lavender
  { bg: '#E8D4D4', fg: '#685454' }, // soft rose
  { bg: '#D4E0E8', fg: '#40536B' }, // soft slate blue
  { bg: '#E8E4D4', fg: '#6B6340' }, // soft wheat
  { bg: '#E4D8D4', fg: '#6B5954' }, // soft terracotta
];

function Avatar({ icon, size = 'md', color, bg, iconColor, children, index }) {
  const sizeMap = { sm: 32, md: 34, lg: 40, xl: 56 };
  const iconSizeMap = { sm: 16, md: 16, lg: 20, xl: 28 };
  const px = sizeMap[size] || 34;
  const iconPx = iconSizeMap[size] || 16;
  
  // If explicit bg/iconColor provided, use those
  // Otherwise use Walle palette (indexed or based on children text)
  let bgColor = bg;
  let fgColor = iconColor;
  
  if (!bg && !iconColor) {
    let paletteIndex = index !== undefined ? index % AVATAR_COLORS.length : 0;
    
    // If children is a string (letter), hash it to pick consistent color
    if (children && typeof children === 'string') {
      const hash = children.charCodeAt(0) || 0;
      paletteIndex = hash % AVATAR_COLORS.length;
    }
    
    const palette = AVATAR_COLORS[paletteIndex];
    bgColor = palette.bg;
    fgColor = palette.fg;
  }
  
  const finalBg = bgColor || color || AVATAR_COLORS[0].bg;
  const finalFg = fgColor || '#fff';
  
  return (
    <div style={{
      width: px,
      height: px,
      borderRadius: '50%',
      background: finalBg,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: finalFg,
      flexShrink: 0,
      fontSize: children ? (size === 'xl' ? 24 : size === 'lg' ? 16 : 14) : undefined,
      fontWeight: children ? 700 : undefined,
    }}>
      {icon ? React.cloneElement(icon, { 
        style: { 
          width: iconPx, 
          height: iconPx, 
          color: finalFg,
          ...(icon.props?.style || {})
        } 
      }) : children}
    </div>
  );
}

// ───────── Button component ─────────
// Shared button component with variants: primary (default), ghost, danger-outline
function Button({ children, variant = 'primary', onClick, disabled, style, className = '' }) {
  const baseStyle = {
    width: '100%',
    padding: '14px 16px',
    fontSize: 15,
    fontWeight: 600,
    border: 0,
    borderRadius: 12,
    cursor: disabled ? 'not-allowed' : 'pointer',
    transition: 'background 0.2s, opacity 0.2s',
    fontFamily: 'inherit',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    ...style,
  };

  let variantStyle = {};
  
  if (variant === 'primary') {
    variantStyle = {
      background: disabled ? 'var(--gz-fg-4)' : 'var(--gz-btn)',
      color: disabled ? 'var(--gz-fg-3)' : '#fff',
    };
  } else if (variant === 'ghost') {
    variantStyle = {
      background: disabled ? 'transparent' : 'var(--gz-pill)',
      color: disabled ? 'var(--gz-fg-3)' : 'var(--gz-fg)',
      border: '1.5px solid var(--gz-rule)',
    };
  } else if (variant === 'danger-outline') {
    variantStyle = {
      background: 'transparent',
      color: 'var(--gz-err)',
      border: '1.5px solid var(--gz-err)',
    };
  }

  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`gz-btn ${className}`}
      style={{ ...baseStyle, ...variantStyle }}
    >
      {children}
    </button>
  );
}

// ───────── Admin shared components ─────────

// Admin bottom nav — 4 tabs: Dashboard, Sessions, Management, Store
function AdminBottomNav({ active = 'dashboard' }) {
  const tabs = [
    { id: 'dashboard',  icon: I.home,   label: 'Floor' },
    { id: 'sessions',   icon: I.clock,  label: 'Sessions' },
    { id: 'management', icon: I.scale,  label: 'Manage' },
    { id: 'store',      icon: I.pc,     label: 'Store' },
  ];
  return (
    <div className="gz-bottomnav" style={{ flexShrink: 0 }}>
      {tabs.map(t => (
        <button key={t.id} data-active={active === t.id}
          style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2,
            color: active === t.id ? 'var(--gz-rose)' : 'var(--gz-fg-4)',
            background: 'transparent', border: 0, padding: 8, cursor: 'pointer', fontFamily: 'inherit' }}>
          {React.cloneElement(t.icon, { style: { width: 20, height: 20 } })}
          <span style={{ fontSize: 10, fontWeight: 600 }}>{t.label}</span>
        </button>
      ))}
    </div>
  );
}

// Admin TopBar — title on the left (not centered), optional back button
function AdminTopBar({ title, subtitle, onBack, trailing }) {
  return (
    <div style={{ padding: '10px 16px 10px', display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
      {onBack && (
        <button onClick={onBack} style={{ width: 36, height: 36, border: 0, background: 'transparent',
          color: 'var(--gz-fg)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 0, cursor: 'pointer' }}>
          {I.back}
        </button>
      )}
      <div style={{ flex: 1 }}>
        <div className="gz-h2">{title}</div>
        {subtitle && <div className="gz-small" style={{ marginTop: 1 }}>{subtitle}</div>}
      </div>
      {trailing && <div style={{ display: 'flex', alignItems: 'center' }}>{trailing}</div>}
    </div>
  );
}

// KPI card used across admin analytics screens
function AdminKpiCard({ label, value, icon, accentColor = 'var(--gz-fg-3)' }) {
  return (
    <div className="gz-card" style={{ flex: 1, padding: 14, borderRadius: 16 }}>
      <div style={{ color: accentColor, marginBottom: 6 }}>
        {React.cloneElement(icon, { style: { width: 18, height: 18 } })}
      </div>
      <div className="gz-h2" style={{ fontFamily: 'var(--gz-mono)' }}>{value}</div>
      <div className="gz-small">{label}</div>
    </div>
  );
}

// Rose filter chip — used in admin filter rows
function AdminChip({ label, active, onClick }) {
  return (
    <button onClick={onClick} style={{
      height: 30, padding: '0 12px', border: 0, borderRadius: 'var(--gz-r-chip)',
      background: active ? 'var(--gz-rose)' : 'var(--gz-card)',
      color: active ? '#fff' : 'var(--gz-fg-2)',
      fontSize: 13, fontWeight: 600, fontFamily: 'inherit', cursor: 'pointer',
      boxShadow: active ? 'none' : 'inset 0 0 0 1px var(--gz-rule)',
    }}>{label}</button>
  );
}

// Toggle switch for admin screens
function AdminToggle({ active = true }) {
  return (
    <div style={{
      width: 44, height: 24, borderRadius: 999, flexShrink: 0,
      background: active ? 'var(--gz-ok)' : 'var(--gz-rule)',
      position: 'relative', transition: 'background 0.2s',
    }}>
      <div style={{
        width: 18, height: 18, borderRadius: 999,
        background: active ? '#fff' : 'var(--gz-fg-4)',
        position: 'absolute', top: 3,
        left: active ? 23 : 3,
        transition: 'left 0.2s',
        boxShadow: '0 1px 3px rgba(0,0,0,0.15)',
      }} />
    </div>
  );
}

// Admin nav tile — used in Management hub and Store hub
function AdminNavTile({ icon, iconColor, label, onClick }) {
  return (
    <div className="gz-card" style={{ padding: 16, borderRadius: 14, cursor: 'pointer' }} onClick={onClick}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
        <div style={{
          width: 36, height: 36, borderRadius: 10,
          background: iconColor + '1A',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          color: iconColor, flexShrink: 0,
        }}>
          {React.cloneElement(icon, { style: { width: 22, height: 22 } })}
        </div>
        <div style={{ flex: 1 }}>
          <div className="gz-h3">{label}</div>
        </div>
        <div style={{ color: 'var(--gz-fg-3)' }}>
          {React.cloneElement(I.chev, { style: { width: 16, height: 16 } })}
        </div>
      </div>
    </div>
  );
}

// Admin input field — reusable input style
function AdminInput({ label, value, placeholder, type = 'text', style: extraStyle }) {
  return (
    <div style={{ marginBottom: 12, ...extraStyle }}>
      {label && <div className="gz-meta" style={{ marginBottom: 4 }}>{label}</div>}
      <div style={{
        background: 'var(--gz-pill-bg)', borderRadius: 10,
        padding: '10px 12px', fontSize: 14, fontFamily: 'var(--gz-font)',
        fontWeight: 500, color: 'var(--gz-fg)',
      }}>{value || placeholder}</div>
    </div>
  );
}

Object.assign(window, {
  I, Phone, StatusBar, TopBar, BottomNav, Scroll,
  Tag, Chip, LiveDot, IconBtn, MetaRow, Collapse, Avatar, AVATAR_COLORS,
  Button,
  AdminBottomNav, AdminTopBar, AdminKpiCard, AdminChip, AdminToggle, AdminNavTile, AdminInput,
});
