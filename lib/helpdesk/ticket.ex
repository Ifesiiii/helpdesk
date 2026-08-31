defmodule Helpdesk.Ticket do
  @derive {Phoenix.Param, key: :reference}

  defstruct [:id, :reference]
end
