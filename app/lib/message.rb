class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_exists
    'Account already exists'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue.'
  end

  def self.login_success
    'Login was successful'
  end 

  def self.report_success
    'Incident was reported successfully'
  end

  def self.update_success
    'Incident was updated successfully'
  end

  def self.delete_success
    'Incident was deleted successfully'
  end

  def self.update_failure
    'Only Incidents marked as draft, can be updated'
  end

  def self.delete_failure
    'Only Incidents marked as draft, can be deleted'
  end
end
