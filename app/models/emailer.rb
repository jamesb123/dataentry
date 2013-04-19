class Emailer < ActionMailer::Base
  def contact(recipient, subject, name, login, password, sent_at = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'info@nrdpfc.ca'
      @sent_on = sent_at
      @body["name"] = name
      @body["email"] = recipient
      @body["login"] = login
      @body["password"] = password
      @headers = {content_type => 'text/html'}
   end
 def submission(recipient, subject, name, project_id, field_code, date_submitted, shipping_date, sent_at = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'info@nrdpfc.ca'
      @reply_to ='mmoeyaert@nrdpfc.ca'
      @sent_on = sent_at
      @body["name"] = name
      @body["email"] = recipient
      @body["project_id"] = project_id
      @body["field_code"] = field_code
      @body["date_submitted"] = date_submitted
      @body["shipping_date"] = shipping_date
      
      @headers = {content_type => 'text/html'}
   end


  def welcome_message(sent_at = Time.now) 
    @subject    = 'Customer Mailer#welcome_message' 
    @body       = {}
    @recipients = '' 
    @from       = '' 
    @sent_on    = sent_at 
    @headers    = {} 
    @body["email"] = '' 
  end   
end