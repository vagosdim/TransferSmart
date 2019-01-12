class UserMailer < ApplicationMailer

  default from: 'notifications@example.com'
 
  def welcome_email
    @user = params[:user]
    @username = @user.email
    puts @username 
    puts 'DEBUG;\n\n\n'
    @url  = 'https://transfersmart.pagekite.me'
    mail(to: "myemail@mailinator.com", subject: 'Welcome to My Awesome Site')
  end

end
