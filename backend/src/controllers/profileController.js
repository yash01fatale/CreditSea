import { validationResult } from 'express-validator';
import User from '../models/User.js';

/**
 * @desc    Get authenticated user's profile
 * @route   GET /api/profile
 * @access  Private
 */
export const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-__v');

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
        data: null,
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Profile fetched successfully',
      data: user,
    });
  } catch (error) {
    console.error('getProfile error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch profile',
      data: null,
    });
  }
};

/**
 * @desc    Update authenticated user's profile
 * @route   PUT /api/profile
 * @access  Private
 */
export const updateProfile = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const allowedFields = ['name', 'dob', 'gender', 'pan', 'email', 'address'];
    const updates = {};

    for (const field of allowedFields) {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    }

    // Determine if profile will be completed after this update
    const currentUser = req.user;
    const mergedName = updates.name || currentUser.name;
    const mergedPan = updates.pan || currentUser.pan;
    const mergedDob = updates.dob || currentUser.dob;

    if (mergedName && mergedPan && mergedDob) {
      updates.profileCompleted = true;
    }

    const user = await User.findByIdAndUpdate(
      req.user._id,
      { $set: updates },
      { new: true, runValidators: true }
    ).select('-__v');

    return res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      data: user,
    });
  } catch (error) {
    console.error('updateProfile error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to update profile',
      data: null,
    });
  }
};
