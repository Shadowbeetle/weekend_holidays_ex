# WeekendHolidays

`WeekendHolidays` is a module four listing, counting holidays based on whether they fall on a weekday or on the weekend,
and aggregating of these data for multple years using statistical functions.

Aggregation of holidays for multple years using statistical functions is usually used with a range of 399 years, as every 400 years the week configuration resets.

400 years is a [Solar cycle]: the progression of weekdays repeats itself every 400 years, that's why a range of 400 years was chosen. Not that it matters, it's a small script, can be rewritten anytime.

## Installation

1. Clone the repo
2. run `mix deps.get`

## Usage

Use with iex

```sh
ies -S mix

iex> WeekendHolidays.aggregate_holidays(2022..2421, :weekday, &Statistics.median/1)
6.0
```

See the docstrings in `lib/weekend_holidays.ex` for further info on specific functions

