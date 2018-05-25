module AuthHelpers
  def authorized?
    env["warden"] && env["warden"].authenticated?
  end

  def protected!
    halt 401,slim(:unauthorized) unless authorized?
  end

  def log_out!
    env["warden"] && env["warden"].logout
  end
end
