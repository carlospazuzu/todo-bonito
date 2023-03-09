class IssueNotification < ApplicationService
  def initialize(task:)
    @task = task
  end

  def call
    build_notification_object.notify(task)
  end

  private 

  attr_reader :task

  NOTIFICATION_DECORATORS = {
    'sms'      => SmsNotificationDecorator,
    'whatsapp' => WhatsappNotificationDecorator,
    'email'     => MailNotificationDecorator,
    'telegram' => TelegramNotificationDecorator
  }.freeze

  def build_notification_object
    NOTIFICATION_DECORATORS
      .select { |notification, notification_decorator| task.user.notification_preferences['task_completed'].include?(notification) }
      .values
      .reduce(TaskNotificationDecorator.new) { |notification, notification_class| notification_class.new(notification) }
  end
end
