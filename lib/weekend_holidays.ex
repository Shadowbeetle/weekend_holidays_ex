defmodule WeekendHolidays do
  @moduledoc """
  Documentation for `WeekendHolidays`.
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
  Hello world.

  ## Examples

      iex> WeekendHolidays.hello()
      :world

  """
  def is_weekend(year, holiday) do
    {month, day} = holiday
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    weekday_of_holiday = date |> Date.day_of_week()
    Enum.member?(@weekend_days, weekday_of_holiday)
  end

  @spec get_holidays(integer(), kind()) :: list(integer())
  def get_holidays(year, :weekend) do
    Enum.filter(@holidays, fn holiday -> is_weekend(year, holiday) end)
  end

  def get_holidays(year, :weekday) do
    Enum.filter(@holidays, fn holiday -> not is_weekend(year, holiday) end)
  end

  @spec count_holidays(integer(), kind()) :: non_neg_integer
  def count_holidays(year, kind) do
    get_holidays(year, kind) |> Enum.count()
  end

  @spec aggregate_holidays(Range, kind(), (list(number()) -> number())) :: any
  def aggregate_holidays(year_range, kind, func) do
    holiday_counts =
      for year <- year_range do
        count_holidays(year, kind)
      end

    func.(holiday_counts)
  end
end
