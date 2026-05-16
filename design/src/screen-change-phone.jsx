function ChangePhoneScreen() {
  const [step, setStep] = React.useState(1); // 1 = new number, 2 = OTP verify, 3 = success
  const [countryCode, setCountryCode] = React.useState('+91');
  const [countryFlag, setCountryFlag] = React.useState('🇮🇳');
  const [phoneNumber, setPhoneNumber] = React.useState('');
  const [showCountryPicker, setShowCountryPicker] = React.useState(false);
  const [otp, setOtp] = React.useState('742');
  const [countdownSeconds, setCountdownSeconds] = React.useState(52);
  const [otpError, setOtpError] = React.useState(false);

  React.useEffect(() => {
    const timer = setInterval(() => {
      setCountdownSeconds(prev => prev > 0 ? prev - 1 : 0);
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const countries = [
    { name: 'India', code: '+91', flag: '🇮🇳' },
    { name: 'UAE', code: '+971', flag: '🇦🇪' },
    { name: 'USA', code: '+1', flag: '🇺🇸' },
    { name: 'UK', code: '+44', flag: '🇬🇧' },
    { name: 'Singapore', code: '+65', flag: '🇸🇬' }
  ];

  const handleCountrySelect = (country) => {
    setCountryCode(country.code);
    setCountryFlag(country.flag);
    setShowCountryPicker(false);
  };

  const handleNumberInput = (e) => {
    const val = e.target.value.replace(/\D/g, '').slice(0, 10);
    setPhoneNumber(val);
  };

  const handleOtpDigit = (num) => {
    if (otp.length < 6) {
      const newOtp = otp + num;
      setOtp(newOtp);
      setOtpError(false);
      if (newOtp.length === 6) {
        setTimeout(() => {
          if (newOtp === '742123') {
            setStep(3);
          } else {
            setOtpError(true);
            setOtp('');
          }
        }, 300);
      }
    }
  };

  const handleOtpBackspace = () => {
    setOtp(otp.slice(0, -1));
  };

  if (step === 3) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--gz-bg)', padding: '20px', boxSizing: 'border-box' }}>
        <div style={{ paddingTop: 20 }} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 20 }}>
          <Avatar size="xl" bg="var(--gz-ok)" icon={I.check} />
          <div style={{ fontSize: 18, fontWeight: 600, textAlign: 'center', color: 'var(--gz-fg)' }}>
            Phone number updated
          </div>
          <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', textAlign: 'center' }}>
            {countryCode} 87654 32109
          </div>
        </div>
      </div>
    );
  }

  if (step === 2) {
    return (
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--gz-bg)', padding: '20px', boxSizing: 'border-box' }}>
        {/* Header */}
        <div style={{ display: 'flex', alignItems: 'center', marginBottom: 24, gap: 12 }}>
          <button onClick={() => setStep(1)} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--gz-fg)', width: 38, height: 38, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {React.cloneElement(I.back, { style: { width: 24, height: 24 } })}
          </button>
          <div style={{ fontSize: 18, fontWeight: 700, color: 'var(--gz-fg)' }}>Verify phone</div>
        </div>

        {/* OTP sent message */}
        <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', marginBottom: 20 }}>
          OTP sent to <span style={{ fontWeight: 600, color: 'var(--gz-fg)' }}>{countryCode} 87654 32109</span>
        </div>

        {/* OTP boxes */}
        <div style={{ display: 'flex', gap: 8, marginBottom: 20, justifyContent: 'center' }}>
          {[0, 1, 2, 3, 4, 5].map(i => (
            <div
              key={i}
              style={{
                width: 44,
                height: 44,
                borderRadius: 8,
                background: otpError ? 'var(--gz-err)' : 'var(--gz-card)',
                border: otpError ? '2px solid #C85E54' : '1px solid var(--gz-rule)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 18,
                fontWeight: 700,
                color: 'var(--gz-fg)',
                animation: otpError ? 'shake 0.3s ease-out' : 'none'
              }}
            >
              {otp[i] || ''}
            </div>
          ))}
        </div>

        {/* Resend countdown */}
        <div style={{ fontSize: 11, color: 'var(--gz-fg-2)', marginBottom: 20, textAlign: 'center' }}>
          Resend in 0:{countdownSeconds < 10 ? '0' : ''}{countdownSeconds}
        </div>

        {/* Verify button */}
        <button
          onClick={() => {
            if (otp.length === 6 && otp === '742123') {
              setStep(3);
            }
          }}
          disabled={otp.length < 6}
          style={{
            width: '100%',
            padding: '12px',
            background: otp.length === 6 ? 'var(--gz-fg)' : '#D5D5D0',
            color: otp.length === 6 ? 'var(--gz-bg)' : 'var(--gz-fg-2)',
            border: 'none',
            borderRadius: 8,
            fontWeight: 600,
            fontSize: 14,
            cursor: otp.length === 6 ? 'pointer' : 'default',
            marginBottom: 12
          }}
        >
          Verify & update
        </button>

        <button style={{ background: 'none', border: 'none', color: 'var(--gz-fg-2)', fontSize: 12, cursor: 'pointer', fontWeight: 500 }}>
          Wrong number? Go back
        </button>

        {/* Number pad */}
        <div style={{ marginTop: 24, display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8 }}>
          {[1, 2, 3, 4, 5, 6, 7, 8, 9].map(num => (
            <button
              key={num}
              onClick={() => handleOtpDigit(num)}
              style={{
                padding: '12px',
                background: 'var(--gz-pill-bg)',
                border: '1px solid var(--gz-rule)',
                borderRadius: 8,
                fontSize: 16,
                fontWeight: 600,
                color: 'var(--gz-fg)',
                cursor: 'pointer'
              }}
            >
              {num}
            </button>
          ))}
        </div>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8, marginTop: 8 }}>
          <button
            onClick={() => handleOtpDigit(0)}
            style={{
              padding: '12px',
              background: 'var(--gz-pill-bg)',
              border: '1px solid var(--gz-rule)',
              borderRadius: 8,
              fontSize: 16,
              fontWeight: 600,
              color: 'var(--gz-fg)',
              cursor: 'pointer'
            }}
          >
            0
          </button>
          <button
            onClick={handleOtpBackspace}
            style={{
              padding: '12px',
              background: 'var(--gz-pill-bg)',
              border: '1px solid var(--gz-rule)',
              borderRadius: 8,
              fontSize: 16,
              fontWeight: 600,
              color: 'var(--gz-fg)',
              cursor: 'pointer'
            }}
          >
            ⌫
          </button>
        </div>

        <style>{`
          @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-4px); }
            75% { transform: translateX(4px); }
          }
        `}</style>
      </div>
    );
  }

  // Step 1 - New number input
  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--gz-bg)', padding: '20px', boxSizing: 'border-box' }}>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', marginBottom: 24, gap: 12 }}>
        <button style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--gz-fg)', width: 38, height: 38, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          {React.cloneElement(I.back, { style: { width: 24, height: 24 } })}
        </button>
        <div style={{ fontSize: 18, fontWeight: 700, color: 'var(--gz-fg)' }}>Change phone number</div>
      </div>

      {/* Current number */}
      <div style={{ background: 'var(--gz-card)', padding: '12px 16px', borderRadius: 8, marginBottom: 20, fontSize: 13, color: 'var(--gz-fg-2)' }}>
        Current: <span style={{ color: 'var(--gz-fg)', fontWeight: 600 }}>+91 98765 43210</span>
      </div>

      {/* Explainer */}
      <div style={{ fontSize: 13, color: 'var(--gz-fg-2)', marginBottom: 20, lineHeight: 1.5 }}>
        Enter your new number. We'll send an OTP to verify it before making the change.
      </div>

      {/* Country picker */}
      <div style={{ marginBottom: 20 }}>
        <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 8 }}>Country</div>
        <button
          onClick={() => setShowCountryPicker(!showCountryPicker)}
          style={{
            width: '100%',
            padding: '12px 16px',
            background: 'var(--gz-card)',
            border: '1px solid var(--gz-rule)',
            borderRadius: 8,
            display: 'flex',
            alignItems: 'center',
            gap: 12,
            cursor: 'pointer',
            fontSize: 14,
            color: 'var(--gz-fg)',
            fontWeight: 500
          }}
        >
          <span style={{ fontSize: 20 }}>{countryFlag}</span>
          <span>{countryCode}</span>
          <span style={{ marginLeft: 'auto', color: 'var(--gz-fg-2)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            {React.cloneElement(I.chevDn, { style: { width: 16, height: 16 } })}
          </span>
        </button>

        {/* Country picker overlay */}
        {showCountryPicker && (
          <div style={{
            marginTop: 8,
            background: 'var(--gz-card)',
            border: '1px solid var(--gz-rule)',
            borderRadius: 8,
            overflow: 'hidden'
          }}>
            {countries.map(country => (
              <button
                key={country.code}
                onClick={() => handleCountrySelect(country)}
                style={{
                  width: '100%',
                  padding: '12px 16px',
                  background: country.code === countryCode ? 'var(--gz-card-tint)' : 'transparent',
                  border: 'none',
                  borderBottom: '1px solid var(--gz-rule)',
                  display: 'flex',
                  alignItems: 'center',
                  gap: 12,
                  cursor: 'pointer',
                  fontSize: 14,
                  color: 'var(--gz-fg)',
                  fontWeight: 500,
                  justifyContent: 'space-between'
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <span style={{ fontSize: 18 }}>{country.flag}</span>
                  <span>{country.name}</span>
                </div>
                {country.code === countryCode && React.cloneElement(I.check, { style: { width: 18, height: 18 } })}
              </button>
            ))}
          </div>
        )}
      </div>

      {/* Phone number input */}
      <div style={{ marginBottom: 20 }}>
        <div style={{ fontSize: 12, fontWeight: 600, color: 'var(--gz-fg)', marginBottom: 8 }}>Phone number</div>
        <div style={{ display: 'flex', alignItems: 'center', background: 'var(--gz-card)', border: '1px solid var(--gz-rule)', borderRadius: 8, paddingLeft: 12, paddingRight: 12, height: 44 }}>
          <span style={{ color: 'var(--gz-fg-2)', fontWeight: 500 }}>{countryCode}</span>
          <input
            autoFocus
            type="tel"
            placeholder="Enter 10-digit number"
            value={phoneNumber}
            onChange={handleNumberInput}
            style={{
              flex: 1,
              border: 'none',
              background: 'none',
              fontSize: 13,
              color: 'var(--gz-fg)',
              outline: 'none',
              marginLeft: 8
            }}
          />
        </div>
        <div style={{ fontSize: 11, color: 'var(--gz-fg-3)', marginTop: 6 }}>
          10 digits, no spaces
        </div>
      </div>

      {/* Send OTP button */}
      <button
        onClick={() => phoneNumber.length === 10 && setStep(2)}
        disabled={phoneNumber.length < 10}
        style={{
          width: '100%',
          padding: '12px',
          background: phoneNumber.length === 10 ? 'var(--gz-fg)' : '#D5D5D0',
          color: phoneNumber.length === 10 ? 'var(--gz-bg)' : 'var(--gz-fg-2)',
          border: 'none',
          borderRadius: 8,
          fontWeight: 600,
          fontSize: 14,
          cursor: phoneNumber.length === 10 ? 'pointer' : 'default',
          marginBottom: 12
        }}
      >
        Send OTP
      </button>

      <button style={{ background: 'none', border: 'none', color: 'var(--gz-fg-2)', fontSize: 12, cursor: 'pointer', fontWeight: 500 }}>
        Cancel
      </button>
    </div>
  );
}

Object.assign(window, { ChangePhoneScreen });
