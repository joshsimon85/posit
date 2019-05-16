module ApplicationHelper
  def fix_url(str)
    if str.start_with?('https://') || str.start_with?('http://')
      str
    else
      "http://#{str}"
    end
  end

  def fix_date(dt)
    dt.strftime('%m/%d/%Y %l:%M%P %Z')
  end
end
