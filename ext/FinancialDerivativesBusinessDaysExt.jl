module FinancialDerivativesBusinessDaysExt

using Dates: Dates, Date
using BusinessDays: HolidayCalendar, bdays
import FinancialDerivatives.Instruments: business_days

function business_days(calendar::Union{HolidayCalendar,Symbol,AbstractString}, t0::Date,
                       t1::Date)
    return Dates.value(bdays(calendar, t0, t1))
end

end # module
