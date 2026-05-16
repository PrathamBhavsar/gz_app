// Screen 24: Credit Transaction History
// Full ledger of credit movements for a store with filter chips and expandable rows

const { useState } = React;

function CreditTransactionHistoryScreen() {
  const [filterActive, setFilterActive] = useState('all');
  const [expandedRow, setExpandedRow] = useState(null);
  const [showBalance, setShowBalance] = useState(true);

  const filters = ['All', 'Earned', 'Redeemed', 'Bonus', 'Expired', 'Adjusted'];

  const transactionData = [
    {
      month: 'April 2025',
      monthKey: 'apr-2025',
      rows: [
        {
          id: 1,
          type: 'earned',
          icon: 'star',
          description: 'Session completed — RTX 4090',
          amount: '+102 credits',
          amountColor: 'var(--gz-ok)',
          timestamp: 'Today, 6:02 PM',
          balance: '850',
          detail: { sessionRef: '#SES-20948', rate: '1 credit per ₹1 spent', txnId: 'TXN-001234' }
        },
        {
          id: 2,
          type: 'redeemed',
          icon: 'up',
          description: 'Credits redeemed for booking BKG-20948',
          amount: '−300 credits',
          amountColor: 'var(--gz-err)',
          timestamp: 'Yesterday',
          balance: '748',
          detail: { bookingRef: 'BKG-20948', rate: '1 credit = ₹0.10', txnId: 'TXN-001233' }
        },
        {
          id: 3,
          type: 'bonus',
          icon: 'gift',
          description: 'Happy Hour bonus — 30% session',
          amount: '+48 credits',
          amountColor: 'var(--gz-ok)',
          timestamp: '18 Apr',
          balance: '1048',
          detail: { campaign: 'Happy Hour Promo', validity: '90 days from earning', txnId: 'TXN-001232' }
        },
        {
          id: 4,
          type: 'adjusted',
          icon: 'refresh',
          description: 'Admin adjustment — dispute resolution',
          amount: '+200 credits',
          amountColor: 'var(--gz-ok)',
          timestamp: '15 Apr',
          balance: '850',
          detail: { reason: 'Dispute resolution', caseId: 'DSP-00842', txnId: 'TXN-001231' }
        }
      ]
    },
    {
      month: 'March 2025',
      monthKey: 'mar-2025',
      rows: [
        {
          id: 5,
          type: 'earned',
          icon: 'star',
          description: 'Session completed — Xbox',
          amount: '+80 credits',
          amountColor: 'var(--gz-ok)',
          timestamp: '28 Mar',
          balance: '650',
          detail: { sessionRef: '#SES-20847', rate: '1 credit per ₹1 spent', txnId: 'TXN-001230' }
        },
        {
          id: 6,
          type: 'expired',
          icon: 'alert',
          description: 'Credits expired — unused after 90 days',
          amount: '−150 credits',
          amountColor: 'var(--gz-fg-3)',
          timestamp: '15 Mar',
          balance: '570',
          detail: { validity: 'Earned on 15 Dec 2024', expiryDate: '15 Mar 2025', txnId: 'TXN-001229' }
        },
        {
          id: 7,
          type: 'earned',
          icon: 'star',
          description: 'Session completed — VR Rig',
          amount: '+90 credits',
          amountColor: 'var(--gz-ok)',
          timestamp: '10 Mar',
          balance: '720',
          detail: { sessionRef: '#SES-20756', rate: '1 credit per ₹1 spent', txnId: 'TXN-001228' }
        }
      ]
    }
  ];

  const getIconForType = (type) => {
    switch(type) {
      case 'earned': return I.star;
      case 'redeemed': return I.up;
      case 'bonus': return I.gift;
      case 'adjusted': return React.cloneElement(I.refresh, { key: 'refresh' });
      case 'expired': return I.warnT;
      default: return I.info;
    }
  };

  const filterTransactions = (rows) => {
    if (filterActive === 'All') return rows;
    return rows.filter(r => {
      const typeMap = {
        'Earned': 'earned',
        'Redeemed': 'redeemed',
        'Bonus': 'bonus',
        'Expired': 'expired',
        'Adjusted': 'adjusted'
      };
      return r.type === typeMap[filterActive];
    });
  };

  return (
    <Phone>
      <TopBar title="Credit history" onBack={() => {}} />

      <Scroll>
        {/* Store context */}
        <div style={{
          background: 'var(--gz-pill-bg)',
          padding: '8px 12px',
          borderRadius: 'var(--gz-r-chip)',
          display: 'inline-block',
          marginBottom: 16,
        }}>
          <span className="gz-small" style={{ color: 'var(--gz-fg-2)', fontWeight: 600 }}>
            GameZone Koramangala
          </span>
        </div>

        {/* Balance summary card */}
        <div className="gz-card" style={{
          background: 'var(--gz-card-tint)',
          marginBottom: 20,
          textAlign: 'center',
        }}>
          <div className="gz-small" style={{ color: 'var(--gz-fg-3)', marginBottom: 6 }}>Current balance</div>
          <div className="gz-hero-md" style={{ color: 'var(--gz-fg)', marginBottom: 4 }}>850</div>
          <div className="gz-body" style={{ color: 'var(--gz-fg-2)' }}>₹85 value</div>
        </div>

        {/* Filter chips */}
        <div className="gz-hscroll" style={{
          marginBottom: 20,
          marginLeft: -16,
          marginRight: -16,
          paddingLeft: 16,
          paddingRight: 16,
        }}>
          {filters.map(f => (
            <button
              key={f}
              onClick={() => setFilterActive(f)}
              className={filterActive === f ? 'gz-chip gz-chip--filled' : 'gz-chip'}
              style={{
                border: filterActive === f ? 0 : `1px solid var(--gz-rule)`,
                flexShrink: 0,
                cursor: 'pointer',
              }}
            >
              {f}
            </button>
          ))}
        </div>

        {/* Transactions */}
        {transactionData.map(monthGroup => (
          <div key={monthGroup.monthKey} style={{ marginBottom: 20 }}>
            {/* Month header */}
            <button
              onClick={() => {}}
              style={{
                width: '100%',
                background: 'transparent',
                border: 0,
                padding: '12px 0',
                marginBottom: 8,
                fontSize: 16,
                fontWeight: 700,
                color: 'var(--gz-fg)',
                fontFamily: 'inherit',
                textAlign: 'left',
              }}
            >
              {monthGroup.month}
            </button>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {filterTransactions(monthGroup.rows).map(row => (
                <div key={row.id}>
                  {/* Transaction row */}
                  <button
                    onClick={() => setExpandedRow(expandedRow === row.id ? null : row.id)}
                    style={{
                      width: '100%',
                      background: 'var(--gz-card)',
                      border: `1px solid var(--gz-rule)`,
                      padding: '12px 14px',
                      borderRadius: 'var(--gz-r-inner)',
                      textAlign: 'left',
                      cursor: 'pointer',
                      fontFamily: 'inherit',
                      opacity: row.type === 'expired' ? 0.65 : 1,
                    }}
                  >
                    <div style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}>
                      <div style={{
                        width: 32,
                        height: 32,
                        borderRadius: 999,
                        background: 'var(--gz-pill-bg)',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        flexShrink: 0,
                        color: row.amountColor,
                      }}>
                        {React.cloneElement(getIconForType(row.type), { style: { width: 16, height: 16 } })}
                      </div>
                      <div style={{ flex: 1 }}>
                        <div className="gz-body" style={{ fontWeight: 600, marginBottom: 4, color: 'var(--gz-fg)' }}>
                          {row.description}
                        </div>
                        <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>
                          {row.timestamp}
                        </div>
                      </div>
                      <div style={{ textAlign: 'right', flexShrink: 0 }}>
                        <div className="gz-body" style={{ fontWeight: 700, color: row.amountColor, marginBottom: 4 }}>
                          {row.amount}
                        </div>
                        {showBalance && (
                          <div className="gz-small" style={{ color: 'var(--gz-fg-3)' }}>
                            {row.balance}
                          </div>
                        )}
                      </div>
                    </div>
                  </button>

                  {/* Expanded details */}
                  {expandedRow === row.id && (
                    <div style={{
                      background: 'var(--gz-card-tint)',
                      borderRadius: '0 0 var(--gz-r-inner) var(--gz-r-inner)',
                      padding: '14px',
                      borderLeft: `1px solid var(--gz-rule)`,
                      borderRight: `1px solid var(--gz-rule)`,
                      borderBottom: `1px solid var(--gz-rule)`,
                      marginTop: -1,
                    }}>
                      {row.detail.sessionRef && <MetaRow label="Session" value={row.detail.sessionRef} />}
                      {row.detail.bookingRef && <MetaRow label="Booking" value={row.detail.bookingRef} />}
                      {row.detail.campaign && <MetaRow label="Campaign" value={row.detail.campaign} />}
                      {row.detail.reason && <MetaRow label="Reason" value={row.detail.reason} />}
                      {row.detail.rate && <MetaRow label="Rate" value={row.detail.rate} />}
                      {row.detail.validity && <MetaRow label="Validity" value={row.detail.validity} />}
                      {row.detail.expiryDate && <MetaRow label="Expired on" value={row.detail.expiryDate} />}
                      {row.detail.caseId && <MetaRow label="Case ID" value={row.detail.caseId} />}
                      <MetaRow label="Transaction ID" value={row.detail.txnId} />
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        ))}

        {/* Toggle balance column */}
        <button
          onClick={() => setShowBalance(!showBalance)}
          style={{
            background: 'transparent',
            border: 0,
            color: 'var(--gz-fg-3)',
            fontSize: 12,
            fontWeight: 600,
            padding: '12px 0',
            cursor: 'pointer',
            fontFamily: 'inherit',
            textDecoration: 'underline',
          }}
        >
          {showBalance ? 'Hide' : 'Show'} balance
        </button>

        {/* Load more */}
        <button className="gz-btn gz-btn--ghost" style={{ marginTop: 20, marginBottom: 12 }}>
          Load more
        </button>
      </Scroll>

      <BottomNav active="wallet" />
    </Phone>
  );
}

window.CreditTransactionHistoryScreen = CreditTransactionHistoryScreen;
