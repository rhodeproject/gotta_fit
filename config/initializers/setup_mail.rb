ActionMailer::Base.smtp_settings = {
    :address              => Figaro.env.email_gateway,
    :port                 => Figaro.env.email_port,
    :domain               => Figaro.env.email_domain,
    :user_name            => Figaro.env.email_user,
    :password             => Figaro.env.email_password,
    :enable_starttls_auto => true
}


