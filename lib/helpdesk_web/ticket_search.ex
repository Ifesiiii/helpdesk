# lib/helpdesk_web/ticket_search.ex
defmodule HelpdeskWeb.TicketSearch do
  import Ecto.Changeset

  @types %{
    query: :string,
    status: {:array, :string},
    priority: :string,
    assignee_id: :integer,
    from: :date,
    to: :date,
    page: :integer
  }

  @doc """
  Validates search params and returns a clean map, or a changeset with errors.
  """
  def parse(params) do
    {%{}, @types}
    |> cast(params, Map.keys(@types))
    |> validate_length(:query, max: 200)
    |> validate_inclusion(:priority, ~w(low normal high urgent))
    |> validate_subset(:status, ~w(open pending on_hold resolved closed))
    |> validate_number(:page, greater_than: 0)
    |> validate_date_range()
    |> apply_action(:search)
  end

  defp validate_date_range(changeset) do
    with from when not is_nil(from) <- get_field(changeset, :from),
         to when not is_nil(to) <- get_field(changeset, :to),
         :gt <- Date.compare(from, to) do
      add_error(changeset, :to, "must be after the start date")
    else
      _ -> changeset
    end
  end
end
