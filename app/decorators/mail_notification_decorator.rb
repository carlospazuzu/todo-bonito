class MailNotificationDecorator < TaskNotificationDecorator
  def notify(task)
    component.notify(task)
    issue_mail_notification(task)
  end

  private

  def issue_mail_notification(task)
    TaskMailer.with(task:).task_completed_notification.deliver_now
  end
end
