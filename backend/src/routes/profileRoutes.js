import { Router } from 'express';
import { body } from 'express-validator';
import { getProfile, updateProfile } from '../controllers/profileController.js';
import { protect } from '../middleware/auth.js';

const router = Router();

// All profile routes are protected
router.use(protect);

/**
 * @route   GET /api/profile
 * @desc    Get authenticated user's profile
 */
router.get('/', getProfile);

/**
 * @route   PUT /api/profile
 * @desc    Update authenticated user's profile
 */
router.put(
  '/',
  [
    body('name')
      .optional()
      .trim()
      .isLength({ min: 2, max: 100 })
      .withMessage('Name must be between 2 and 100 characters'),
    body('email')
      .optional()
      .isEmail()
      .withMessage('Please provide a valid email address')
      .normalizeEmail(),
    body('dob')
      .optional()
      .isISO8601()
      .withMessage('Please provide a valid date of birth (YYYY-MM-DD)'),
    body('gender')
      .optional()
      .isIn(['Male', 'Female', 'Other'])
      .withMessage('Gender must be Male, Female, or Other'),
    body('pan')
      .optional()
      .matches(/^[A-Z]{5}[0-9]{4}[A-Z]{1}$/)
      .withMessage('PAN must be in valid format (e.g. ABCDE1234F)'),
    body('address')
      .optional()
      .trim()
      .isLength({ min: 5, max: 500 })
      .withMessage('Address must be between 5 and 500 characters'),
  ],
  updateProfile
);

export default router;
