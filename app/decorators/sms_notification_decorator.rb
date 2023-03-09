class SmsNotificationDecorator < TaskNotificationDecorator
  def notify(task)
    component.notify(task)
    issue_sms_notification(task)
  end

  private 

  def issue_sms_notification(task)
    sms_client = FakeSmsClient.new(
      account_id: ENV.fetch('FAKE_SMS_ACCOUNT_ID'),
      auth_token: ENV.fetch('FAKE_SMS_AUTH_TOKEN')
    )
    sms_client.send_sms(
      from: ENV.fetch('FAKE_SMS_PHONE_NUMBER'),
      to: task.user.phone_number,
      body: "Task \"#{task.name}\" completed!"
    )
  end
end