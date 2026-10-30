import mongoose from 'mongoose';

const loanSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User ID is required'],
  },
  amount: {
    type: Number,
    required: [true, 'Loan amount is required'],
    min: [10000, 'Minimum loan amount is ₹10,000'],
    max: [1000000, 'Maximum loan amount is ₹10,00,000'],
  },
  tenure: {
    type: Number,
    required: [true, 'Loan tenure is required'],
    min: [3, 'Minimum tenure is 3 months'],
    max: [60, 'Maximum tenure is 60 months'],
  },
  interestRate: {
    type: Number,
    default: 12,
  },
  emi: {
    type: Number,
  },
  totalPayable: {
    type: Number,
  },
  purpose: {
    type: String,
    enum: ['Personal', 'Education', 'Medical', 'Home', 'Business', 'Other'],
  },
  status: {
    type: String,
    enum: ['Submitted', 'Under Review', 'Approved', 'Rejected', 'Disbursed'],
    default: 'Submitted',
  },
  rejectionReason: {
    type: String,
  },
  appliedAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
  statusHistory: [
    {
      status: { type: String },
      date: { type: Date, default: Date.now },
      note: { type: String },
    },
  ],
});

const Loan = mongoose.model('Loan', loanSchema);

export default Loan;
