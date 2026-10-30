/**
 * Protects demo/admin-only loan status changes.
 * Configure ADMIN_API_KEY in the backend environment; never ship it in the mobile app.
 */
export const requireAdmin = (req, res, next) => {
  const configuredKey = process.env.ADMIN_API_KEY;
  const suppliedKey = req.get('x-admin-key');
  if (!configuredKey || !suppliedKey || suppliedKey !== configuredKey) {
    return res.status(403).json({
      success: false,
      message: 'Admin authorization required',
      data: null,
    });
  }
  next();
};
