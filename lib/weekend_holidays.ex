defmodule WeekendHolidays do
  @moduledoc """
  `WeekendHolidays` is a module four listing, counting holidays based on whether they fall on a weekday or on the weekend,
  and aggregating of these data for multple years using statistical functions.
  """

  @holidays [
    {"01", "01"},
    {"03", "15"},
    {"05", "01"},
    {"08", "20"},
    {"10", "23"},
    {"11", "01"},
    {"12", "25"},
    {"12", "26"}
  ]

  @weekend_days [6, 7]

  @type month :: integer()
  @type day :: integer()
  @type date_tuple :: {month(), day()}

  @type kind :: :weekend | :weekday

  @spec is_weekend(integer(), date_tuple()) :: boolean()
  @doc """
  Whether a day falls on the weekend.

  ## Examples

      iex> WeekendHolidays.is_weekend(2022, {10, 15})
      true

      iex> WeekendHolidays.is_weekend(2023, {10, 16})
      false

  """
  def is_weekend(year, holiday) do
    {month, day} = holiday
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    weekday_of_holiday = date |> Date.day_of_week()
    Enum.member?(@weekend_days, weekday_of_holiday)
  end

  @spec get_holidays(integer(), kind()) :: list(integer())
  @doc """
  List holidays of a given year based on if they fall on a weekday or on the weekend

  ## Examples

      iex> WeekendHolidays.get_holidays(2022, :weekend)
      [{"01", "01"}, {"05", "01"}, {"08", "20"}, {"10", "23"}, {"12", "25"}]

      iex> WeekendHolidays.get_holidays(2022, :weekday)
      [{"03", "15"}, {"11", "01"}, {"12", "26"}]

  """
  def get_holidays(year, :weekend) do
    Enum.filter(@holidays, fn holiday -> is_weekend(year, holiday) end)
  end

  def get_holidays(year, :weekday) do
    Enum.filter(@holidays, fn holiday -> not is_weekend(year, holiday) end)
  end

  @spec count_holidays(integer(), kind()) :: non_neg_integer
  @doc """
  Count holidays of a given year based on if they fall on a weekday or on the weekend

  ## Examples

      iex> WeekendHolidays.count_holidays(2022, :weekend)
      5

      iex> WeekendHolidays.count_holidays(2022, :weekday)
      3

  """
  def count_holidays(year, kind) do
    get_holidays(year, kind) |> Enum.count()
  end

  @spec aggregate_holidays(Range, kind(), (list(number()) -> number())) :: any
  @doc """
  Aggregate holidays for multple years using statistical functions based on if they fall on a weekday or on the weekend.
  Usually used with a range of 399 years, as every 400 years the week configuration resets.

  ## Examples

      iex> WeekendHolidays.aggregate_holidays(2022..2421, :weekend, &Statistics.mean/1)
      2.285

      iex> WeekendHolidays.aggregate_holidays(2022..2421, :weekday, &Statistics.median/1)
      6.0

  """
  def aggregate_holidays(year_range, kind, func) do
    holiday_counts =
      for year <- year_range do
        count_holidays(year, kind)
      end

    func.(holiday_counts)
  end
end
