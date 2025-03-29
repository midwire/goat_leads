# frozen_string_literal: true

# Some common date-time formats
# use timeobj.to_formatted_s(:posted)
Time::DATE_FORMATS[:month_day_comma_year] = '%B %e, %Y' # January 28, 2015
Time::DATE_FORMATS[:mdy_slash] = '%m/%d/%Y'
Time::DATE_FORMATS[:ymd] = '%Y-%m-%d'
Time::DATE_FORMATS[:db] = '%Y-%m-%d %H:%M:%S'

Date::DATE_FORMATS[:month_day_comma_year] = '%B %e, %Y' # January 28, 2015
Date::DATE_FORMATS[:mdy_slash] = '%m/%d/%Y'
Date::DATE_FORMATS[:ymd] = '%Y-%m-%d'
Date::DATE_FORMATS[:db] = '%Y-%m-%d'
