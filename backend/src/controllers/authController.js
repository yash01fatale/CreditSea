import jwt from 'jsonwebtoken';
import { validationResult } from 'express-validator';
import User from '../models/User.js';
import OTP from '../models/OTP.js';
import generateOTP from '../utils/generateOTP.js';

/**
 * @desc    Send OTP to phone number
 * @route   POST /api/auth/send-otp
 * @access  Public
 */
export const sendOTP = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const { phone } = req.body;

    // Invalidate any existing OTPs for this phone
    await OTP.deleteMany({ phone });

    // Generate new OTP
    const otp = generateOTP();

    // Save OTP to database (expires in 5 minutes)
    await OTP.create({
      phone,
      otp,
      expiresAt: new Date(Date.now() + 5 * 60 * 1000),
    });

    // Mock: Log OTP to console (in production, send via SMS)
    console.log(`[OTP] Phone: ${phone} | OTP: ${otp}`);

    return res.status(200).json({
      success: true,
      message: 'OTP sent successfully',
      data: { phone },
    });
  } catch (error) {
    console.error('sendOTP error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to send OTP',
      data: null,
    });
  }
};

/**
 * @desc    Verify OTP and login/register user
 * @route   POST /api/auth/verify-otp
 * @access  Public
 */
export const verifyOTP = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const { phone, otp } = req.body;

    // Find the latest OTP for this phone
    const otpRecord = await OTP.findOne({ phone, verified: false })
      .sort({ createdAt: -1 });

    if (!otpRecord) {
      return res.status(400).json({
        success: false,
        message: 'No OTP found for this phone number. Please request a new OTP.',
        data: null,
      });
    }

    // Check if OTP has expired
    if (new Date() > otpRecord.expiresAt) {
      return res.status(400).json({
        success: false,
        message: 'OTP has expired. Please request a new OTP.',
        data: null,
      });
    }

    // Verify OTP
    if (otpRecord.otp !== otp) {
      return res.status(400).json({
        success: false,
        message: 'Invalid OTP. Please try again.',
        data: null,
      });
    }

    // Mark OTP as verified
    otpRecord.verified = true;
    await otpRecord.save();

    // Find or create user
    let user = await User.findOne({ phone });
    let isNewUser = false;

    if (!user) {
      user = await User.create({ phone });
      isNewUser = true;
    }

    // Generate JWT token
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRE,
    });

    return res.status(200).json({
      success: true,
      message: isNewUser ? 'Registration successful' : 'Login successful',
      data: {
        token,
        user: {
          id: user._id,
          phone: user.phone,
          name: user.name,
          profileCompleted: user.profileCompleted,
        },
      },
    });
  } catch (error) {
    console.error('verifyOTP error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to verify OTP',
      data: null,
    });
  }
};
