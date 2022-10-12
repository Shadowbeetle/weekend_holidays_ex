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

  @spec get_weekend_holidays(integer()) :: list(integer())
  def get_weekend_holidays(year) do
    Enum.filter(@holidays, fn holiday -> is_weekend(year, holiday) end)
  end

  @spec get_week_holidays(integer()) :: list(integer())
  def get_week_holidays(year) do
    Enum.filter(@holidays, fn holiday -> not is_weekend(year, holiday) end)
  end

  @spec count_weekend_holidays(integer) :: non_neg_integer
  def count_weekend_holidays(year) do
    get_weekend_holidays(year) |> Enum.count()
  end

  @spec count_week_holidays(integer) :: non_neg_integer
  def count_week_holidays(year) do
    get_week_holidays(year) |> Enum.count()
  end

  @spec aggregate_week_holidays(Range, (list(number()) -> number())) :: any
  def aggregate_week_holidays(year_range, func) do
    holiday_counts =
      for year <- year_range do
        count_week_holidays(year)
      end

    func.(holiday_counts)
  end

  @spec aggregate_weekend_holidays(Range, (list(number()) -> number())) :: any
  def aggregate_weekend_holidays(year_range, func) do
    holiday_counts =
      for year <- year_range do
        count_weekend_holidays(year)
      end

    func.(holiday_counts)
  end
end
