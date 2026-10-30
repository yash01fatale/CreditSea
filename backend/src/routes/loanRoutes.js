import { Router } from 'express';
import { body } from 'express-validator';
import {
  calculateLoan,
  applyLoan,
  getLoans,
  getLoanById,
  updateLoanStatus,
  getCreditScore,
} from '../controllers/loanController.js';
import { protect } from '../middleware/auth.js';
import { requireAdmin } from '../middleware/admin.js';

const router = Router();

// All loan routes are protected
router.use(protect);

// Validation rules for loan amount and tenure
const loanValidation = [
  body('amount')
    .notEmpty()
    .withMessage('Loan amount is required')
    .isNumeric()
    .withMessage('Loan amount must be a number')
    .isFloat({ min: 10000, max: 1000000 })
    .withMessage('Loan amount must be between ₹10,000 and ₹10,00,000'),
  body('tenure')
    .notEmpty()
    .withMessage('Loan tenure is required')
    .isNumeric()
    .withMessage('Tenure must be a number')
    .isInt({ min: 3, max: 60 })
    .withMessage('Tenure must be between 3 and 60 months'),
];

/**
 * @route   POST /api/loan/calculate
 * @desc    Calculate EMI for given amount and tenure
 */
router.post('/calculate', loanValidation, calculateLoan);

/**
 * @route   POST /api/loan/apply
 * @desc    Apply for a new loan
 */
router.post(
  '/apply',
  [
    ...loanValidation,
    body('purpose')
      .optional()
      .isIn(['Personal', 'Education', 'Medical', 'Home', 'Business', 'Other'])
      .withMessage('Purpose must be one of: Personal, Education, Medical, Home, Business, Other'),
  ],
  applyLoan
);

/**
 * @route   GET /api/loan/applications
 * @desc    Get all loans for authenticated user
 */
router.get('/applications', getLoans);

/**
 * @route   GET /api/loan/credit-score
 * @desc    Get user's current credit score
 */
router.get('/credit-score', getCreditScore);

/**
 * @route   GET /api/loan/:id
 * @desc    Get single loan by ID
 */
router.get('/:id', getLoanById);

/**
 * @route   PUT /api/loan/:id/status
 * @desc    Update loan status (admin/demo)
 */
router.put(
  '/:id/status',
  requireAdmin,
  [
    body('status')
      .notEmpty()
      .withMessage('Status is required')
      .isIn(['Submitted', 'Under Review', 'Approved', 'Rejected', 'Disbursed'])
      .withMessage('Invalid status value'),
    body('rejectionReason')
      .optional()
      .trim()
      .isLength({ min: 5 })
      .withMessage('Rejection reason must be at least 5 characters'),
  ],
  updateLoanStatus
);

export default router;
