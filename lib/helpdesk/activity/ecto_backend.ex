defmodule Helpdesk.Activity.EctoBackend do
  alias Helpdesk.Repo
  alias Helpdesk.Activity.Event

  def record(scope, type, subject, metadata) do
    %Event{}
    |> Event.changeset(%{
      organization_id: scope.organization.id,
      actor_id: scope.user && scope.user.id,
      type: to_string(type),
      subject_type:
        subject.__struct__
        |> Module.split()
        |> List.last(),
      subject_id: subject.id,
      metadata: Map.new(metadata)
    })
    |> Repo.insert()
  end
end
