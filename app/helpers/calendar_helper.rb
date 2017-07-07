module CalendarHelper
  def month_calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  def week_calendar(date = Date.today, &block)
    Week.new(self, date, block)
  end

  class Week < Struct.new(:view, :date, :callback)
    HEADER = %w[Time Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    START_DAY = :sunday
    HOURS = %w[12a 1a 2a 3a 4a 5a 6a 7a 8a 9a 10a 11a
            12p 1p 2p 3p 4p 5p 6p 7p 8p 9p 10p 11p]

    def table
      content_tag :table, class: "calendar" do
        header + hour_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def hour_rows
      content_tag :tr do 
        HOURS.map { |day| content_tag :th, class: "hour" }.join.html_safe
      end
    end

    def week
      first = date.beginning_of_week(START_DAY)
      last = date.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end

  class Calendar < Struct.new(:view, :date, :callback)
    HEADER = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    START_DAY = :sunday
    HOURS = %w[12a 1a 2a 3a 4a 5a 6a 7a 8a 9a 10a 11a
            12p 1p 2p 3p 4p 5p 6p 7p 8p 9p 10p 11p]

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == Date.today
      classes << "notmonth" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end