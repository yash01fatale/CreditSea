/**
 * Check loan eligibility for a user
 *
 * Rules:
 * - Credit score must be >= 650
 * - Profile must be completed (name, pan, dob required)
 * - Age must be between 21 and 60
 * - Loan amount must not exceed 10x of mock base income (₹50,000)
 *
 * @param {object} user - User document from database
 * @param {number} loanAmount - Requested loan amount
 * @returns {{ eligible: boolean, reasons: string[] }}
 */
const checkEligibility = (user, loanAmount) => {
  const reasons = [];
  const MOCK_BASE_INCOME = 50000;
  const MAX_LOAN_MULTIPLIER = 10;

  // Check credit score
  if (!user.creditScore || user.creditScore < 650) {
    reasons.push(
      `Credit score (${user.creditScore || 0}) is below the minimum required score of 650`
    );
  }

  // Check profile completion
  if (!user.name) {
    reasons.push('Name is required to apply for a loan');
  }
  if (!user.pan) {
    reasons.push('PAN number is required to apply for a loan');
  }
  if (!user.dob) {
    reasons.push('Date of birth is required to apply for a loan');
  }

  // Check age (21-60)
  if (user.dob) {
    const today = new Date();
    const birthDate = new Date(user.dob);
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDiff = today.getMonth() - birthDate.getMonth();

    if (
      monthDiff < 0 ||
      (monthDiff === 0 && today.getDate() < birthDate.getDate())
    ) {
      age--;
    }

    if (age < 21) {
      reasons.push(`Applicant must be at least 21 years old (current age: ${age})`);
    }
    if (age > 60) {
      reasons.push(`Applicant must be 60 years or younger (current age: ${age})`);
    }
  }

  // Check loan amount against income
  const maxLoanAmount = MOCK_BASE_INCOME * MAX_LOAN_MULTIPLIER;
  if (loanAmount > maxLoanAmount) {
    reasons.push(
      `Loan amount ₹${loanAmount.toLocaleString('en-IN')} exceeds maximum eligible amount of ₹${maxLoanAmount.toLocaleString('en-IN')}`
    );
  }

  return {
    eligible: reasons.length === 0,
    reasons,
  };
};

export default checkEligibility;
