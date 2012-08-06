class EmailerController < ApplicationController
def sendmail
      recipient = params[:email]
      subject = params[:subject]
      message = params[:message]
      Emailer.deliver_contact(recipient, subject, message)
      return if request.xhr?
      render :text => 'Message sent successfully'
   end
end
