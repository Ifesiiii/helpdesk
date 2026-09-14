defmodule Helpdesk.Accounts.Scope do
  alias Helpdesk.Accounts.User

  defstruct user: nil, organization: nil

  def for_user(%User{} = user) do
    user = Helpdesk.Repo.preload(user, :organization)

    %__MODULE__{
      user: user,
      organization: user.organization
    }
  end

  def for_user(nil), do: nil
end
