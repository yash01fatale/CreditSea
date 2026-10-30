import { Router } from 'express';
import { body } from 'express-validator';
import { sendOTP, verifyOTP } from '../controllers/authController.js';

const router = Router();

/**
 * @route   POST /api/auth/send-otp
 * @desc    Send OTP to phone number
 */
router.post(
  '/send-otp',
  [
    body('phone')
      .notEmpty()
      .withMessage('Phone number is required')
      .matches(/^\d{10}$/)
      .withMessage('Phone number must be exactly 10 digits'),
  ],
  sendOTP
);

/**
 * @route   POST /api/auth/verify-otp
 * @desc    Verify OTP and login/register
 */
router.post(
  '/verify-otp',
  [
    body('phone')
      .notEmpty()
      .withMessage('Phone number is required')
      .matches(/^\d{10}$/)
      .withMessage('Phone number must be exactly 10 digits'),
    body('otp')
      .notEmpty()
      .withMessage('OTP is required')
      .matches(/^\d{6}$/)
      .withMessage('OTP must be exactly 6 digits'),
  ],
  verifyOTP
);

export default router;
