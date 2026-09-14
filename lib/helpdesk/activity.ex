defmodule Helpdesk.Activity do
  alias Helpdesk.Accounts.Scope

  @backend Helpdesk.Activity.AgentBackend

  def record(
        %Scope{} = scope,
        type,
        subject,
        metadata \\ %{}
      ) do
    @backend.record(scope, type, subject, metadata)
  end
end
