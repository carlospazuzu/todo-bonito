class WhatsappNotificationDecorator < TaskNotificationDecorator
  def notify(task)
    component.notify(task)
    issue_whatsapp_notification(task)
  end

  private

  def issue_whatsapp_notification(task)
    whatsapp_client = FakeWhatsappClient.new(
      account_id: ENV.fetch('FAKE_WHATSAPP_ACCOUNT_ID'),
      auth_token: ENV.fetch('FAKE_WHATSAPP_AUTH_TOKEN')
    )
    whatsapp_client.send_message(
      from: "whatsapp:#{ENV.fetch('FAKE_WHATSAPP_PHONE_NUMBER')}",
      to: "whatsapp:#{task.user.phone_number}",
      body: "Task \"#{task.name}\" completed!"
    )
  end
end