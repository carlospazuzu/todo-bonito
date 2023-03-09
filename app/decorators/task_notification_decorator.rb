class TaskNotificationDecorator
  def initialize(component = nil)
    @component = component
  end

  def notify(task = nil); end

  private

  attr_reader :component
end
