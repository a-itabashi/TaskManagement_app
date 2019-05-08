class TaskDecorator < Draper::Decorator
  delegate_all

  def deadline_column
    self.deadline.strftime("%Y年%m月%d日")
  end

end
