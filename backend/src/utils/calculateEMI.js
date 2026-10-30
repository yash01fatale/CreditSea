/**
 * Calculate EMI using the standard reducing balance formula
 * EMI = P × r × (1+r)^n / ((1+r)^n - 1)
 *
 * @param {number} principal - Loan amount
 * @param {number} annualRate - Annual interest rate (e.g. 12 for 12%)
 * @param {number} tenureMonths - Loan tenure in months
 * @returns {{ emi: number, totalPayable: number, totalInterest: number }}
 */
const calculateEMI = (principal, annualRate, tenureMonths) => {
  const r = annualRate / 12 / 100; // Monthly interest rate
  const n = tenureMonths;

  let emi;

  if (r === 0) {
    // Edge case: 0% interest
    emi = principal / n;
  } else {
    const factor = Math.pow(1 + r, n);
    emi = (principal * r * factor) / (factor - 1);
  }

  emi = Math.round(emi * 100) / 100;
  const totalPayable = Math.round(emi * n * 100) / 100;
  const totalInterest = Math.round((totalPayable - principal) * 100) / 100;

  return {
    emi,
    totalPayable,
    totalInterest,
  };
};

export default calculateEMI;
