import { validationResult } from 'express-validator';
import Loan from '../models/Loan.js';
import User from '../models/User.js';
import calculateEMI from '../utils/calculateEMI.js';
import checkEligibility from '../utils/checkEligibility.js';

/**
 * @desc    Calculate EMI for given amount and tenure
 * @route   POST /api/loan/calculate
 * @access  Private
 */
export const calculateLoan = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const { amount, tenure, interestRate = 12 } = req.body;

    const emiDetails = calculateEMI(amount, interestRate, tenure);

    return res.status(200).json({
      success: true,
      message: 'EMI calculated successfully',
      data: {
        amount,
        tenure,
        interestRate,
        ...emiDetails,
      },
    });
  } catch (error) {
    console.error('calculateLoan error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to calculate EMI',
      data: null,
    });
  }
};

/**
 * @desc    Apply for a new loan
 * @route   POST /api/loan/apply
 * @access  Private
 */
export const applyLoan = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const { amount, tenure, purpose, interestRate = 12 } = req.body;
    const user = req.user;

    // Check eligibility
    const eligibility = checkEligibility(user, amount);
    if (!eligibility.eligible) {
      return res.status(400).json({
        success: false,
        message: 'Loan application rejected due to eligibility criteria',
        data: {
          eligible: false,
          reasons: eligibility.reasons,
        },
      });
    }

    // Calculate EMI
    const emiDetails = calculateEMI(amount, interestRate, tenure);

    // Create loan application
    const loan = await Loan.create({
      userId: user._id,
      amount,
      tenure,
      interestRate,
      emi: emiDetails.emi,
      totalPayable: emiDetails.totalPayable,
      purpose: purpose || 'Personal',
      status: 'Submitted',
      statusHistory: [
        {
          status: 'Submitted',
          date: new Date(),
          note: 'Loan application submitted',
        },
      ],
    });

    return res.status(201).json({
      success: true,
      message: 'Loan application submitted successfully',
      data: loan,
    });
  } catch (error) {
    console.error('applyLoan error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to submit loan application',
      data: null,
    });
  }
};

/**
 * @desc    Get all loans for authenticated user
 * @route   GET /api/loan/applications
 * @access  Private
 */
export const getLoans = async (req, res) => {
  try {
    const loans = await Loan.find({ userId: req.user._id })
      .sort({ appliedAt: -1 });

    return res.status(200).json({
      success: true,
      message: 'Loans fetched successfully',
      data: {
        count: loans.length,
        loans,
      },
    });
  } catch (error) {
    console.error('getLoans error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch loans',
      data: null,
    });
  }
};

/**
 * @desc    Get single loan by ID
 * @route   GET /api/loan/:id
 * @access  Private
 */
export const getLoanById = async (req, res) => {
  try {
    const loan = await Loan.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!loan) {
      return res.status(404).json({
        success: false,
        message: 'Loan application not found',
        data: null,
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Loan fetched successfully',
      data: loan,
    });
  } catch (error) {
    console.error('getLoanById error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch loan',
      data: null,
    });
  }
};

/**
 * @desc    Update loan status (admin/demo purposes)
 * @route   PUT /api/loan/:id/status
 * @access  Private
 */
export const updateLoanStatus = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const { status, note, rejectionReason } = req.body;

    const loan = await Loan.findById(req.params.id);

    if (!loan) {
      return res.status(404).json({
        success: false,
        message: 'Loan application not found',
        data: null,
      });
    }

    // Update loan status
    loan.status = status;
    loan.updatedAt = new Date();

    if (rejectionReason && status === 'Rejected') {
      loan.rejectionReason = rejectionReason;
    }

    // Add to status history
    loan.statusHistory.push({
      status,
      date: new Date(),
      note: note || `Status updated to ${status}`,
    });

    await loan.save();

    // Update credit score based on status change
    if (status === 'Approved') {
      await User.findByIdAndUpdate(loan.userId, {
        $inc: { creditScore: 10 },
      });
    } else if (status === 'Rejected') {
      await User.findByIdAndUpdate(loan.userId, {
        $inc: { creditScore: -5 },
      });
    }

    return res.status(200).json({
      success: true,
      message: `Loan status updated to ${status}`,
      data: loan,
    });
  } catch (error) {
    console.error('updateLoanStatus error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to update loan status',
      data: null,
    });
  }
};

/**
 * @desc    Get user's current credit score
 * @route   GET /api/loan/credit-score
 * @access  Private
 */
export const getCreditScore = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('creditScore phone name');

    return res.status(200).json({
      success: true,
      message: 'Credit score fetched successfully',
      data: {
        creditScore: user.creditScore,
        phone: user.phone,
        name: user.name,
      },
    });
  } catch (error) {
    console.error('getCreditScore error:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch credit score',
      data: null,
    });
  }
};
