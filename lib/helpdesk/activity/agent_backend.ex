defmodule Helpdesk.Activity.AgentBackend do
  use Agent

  def start_link(_opts) do
    Agent.start_link(
      fn -> [] end,
      name: __MODULE__
    )
  end

  def record(scope, type, subject, metadata) do
    event = %{
      organization_id: scope.organization.id,
      actor_id: scope.user && scope.user.id,
      type: type,
      subject_type:
        subject.__struct__
        |> Module.split()
        |> List.last(),
      subject_id: subject.id,
      metadata: Map.new(metadata)
    }

    Agent.update(
      __MODULE__,
      &[event | &1]
    )

    {:ok, event}
  end
end
