defmodule Helpdesk.Accounts.Organization.Settings do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :business_hours_start, :time, default: ~T[09:00:00]
    field :business_hours_end, :time, default: ~T[17:00:00]
    field :timezone, :string, default: "Africa/Lagos"
    field :auto_close_after_days, :integer, default: 14
    field :notify_on_new_ticket, :boolean, default: true
  end

  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [:business_hours_start, :business_hours_end, :timezone,
                    :auto_close_after_days, :notify_on_new_ticket])
    |> validate_number(:auto_close_after_days, greater_than: 0, less_than_or_equal_to: 365)
    |> validate_inclusion(:timezone, Tzdata.zone_list())
    |> validate_hours_order()
  end

  defp validate_hours_order(changeset) do
    start = get_field(changeset, :business_hours_start)
    finish = get_field(changeset, :business_hours_end)

    if start && finish && Time.compare(start, finish) != :lt do
      add_error(changeset, :business_hours_end, "must be after the start time")
    else
      changeset
    end
  end
end
