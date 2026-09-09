# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Helpdesk.Repo.insert!(%Helpdesk.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


# priv/repo/seeds.exs

alias Helpdesk.Repo
alias Helpdesk.Accounts.{Organization, User}
alias Helpdesk.Tickets.Ticket

now = DateTime.utc_now(:second)

# -------------------------------------------------
# Organizations
# -------------------------------------------------

acme =
  Repo.insert!(%Organization{
    name: "Acme Corp",
    slug: "acme",
    plan: :team
  })

globex =
  Repo.insert!(%Organization{
    name: "Globex Corporation",
    slug: "globex",
    plan: :business
  })

initech =
  Repo.insert!(%Organization{
    name: "Initech",
    slug: "initech",
    plan: :starter
  })

# -------------------------------------------------
# Users
#
# Acme    -> 7 users
# Globex  -> 6 users
# Initech -> 5 users
# Total   -> 18 users
# -------------------------------------------------

create_user = fn organization, number, role ->
  Repo.insert!(%User{
    email: "user#{number}@#{organization.slug}.test",
    name: "#{organization.name} User #{number}",
    role: role,
    organization_id: organization.id,
    confirmed_at: now
  })
end

acme_users = [
  create_user.(acme, 1, :owner),
  create_user.(acme, 2, :admin),
  create_user.(acme, 3, :agent),
  create_user.(acme, 4, :agent),
  create_user.(acme, 5, :agent),
  create_user.(acme, 6, :agent),
  create_user.(acme, 7, :agent)
]

globex_users = [
  create_user.(globex, 1, :owner),
  create_user.(globex, 2, :admin),
  create_user.(globex, 3, :agent),
  create_user.(globex, 4, :agent),
  create_user.(globex, 5, :agent),
  create_user.(globex, 6, :agent)
]

initech_users = [
  create_user.(initech, 1, :owner),
  create_user.(initech, 2, :admin),
  create_user.(initech, 3, :agent),
  create_user.(initech, 4, :agent),
  create_user.(initech, 5, :agent)
]

# -------------------------------------------------
# Exact ticket distributions
#
# Status:
# 60 resolved
# 8 closed
# 6 open
# 3 pending
# 3 on_hold
#
# Priority:
# 16 low
# 53 normal
# 10 high
# 1 urgent
#
# Total: 80
# -------------------------------------------------

statuses =
  List.duplicate(:resolved, 60) ++
    List.duplicate(:closed, 8) ++
    List.duplicate(:open, 6) ++
    List.duplicate(:pending, 3) ++
    List.duplicate(:on_hold, 3)

priorities =
  List.duplicate(:low, 16) ++
    List.duplicate(:normal, 52) ++
    List.duplicate(:high, 10) ++
    [:urgent]

# Move the urgent priority onto one of the open tickets.
priorities =
  priorities
  |> List.replace_at(68, :urgent)
  |> List.replace_at(79, :normal)

# -------------------------------------------------
# Organization distribution
#
# Acme    -> 30 tickets
# Globex  -> 26 tickets
# Initech -> 24 tickets
# -------------------------------------------------

ticket_organizations =
  List.duplicate({acme, acme_users}, 30) ++
    List.duplicate({globex, globex_users}, 26) ++
    List.duplicate({initech, initech_users}, 24)

subjects = [
  "Printer is not responding",
  "Cannot log in from mobile",
  "Invoice shows incorrect VAT",
  "Email notifications are delayed",
  "Export produces an empty CSV",
  "Unable to reset password",
  "Dashboard is loading slowly",
  "Attachment upload fails",
  "Account access problem",
  "Report contains incorrect figures",
  "Search is not returning results",
  "Unable to update profile",
  "Ticket notification missing",
  "Application session expires early",
  "Unable to download report"
]

Enum.zip([statuses, priorities, ticket_organizations])
|> Enum.with_index(1)
|> Enum.each(fn {{status, priority, {organization, users}}, index} ->
  requester =
    Enum.at(
      users,
      rem(index - 1, length(users))
    )

  agents =
    Enum.filter(
      users,
      &(&1.role == :agent)
    )

  assignee =
    if rem(index, 5) == 0 do
      nil
    else
      Enum.at(
        agents,
        rem(index - 1, length(agents))
      )
    end

  subject =
    Enum.at(
      subjects,
      rem(index - 1, length(subjects))
    )

  Repo.insert!(%Ticket{
    reference:
      "HD-#{String.pad_leading(Integer.to_string(index), 4, "0")}",
    subject: "#{subject} ##{index}",
    body:
      "Detailed description for support ticket #{index}: #{subject}.",
    status: status,
    priority: priority,
    organization_id: organization.id,
    requester_id: requester.id,
    assignee_id: if(assignee, do: assignee.id, else: nil),
    resolved_at:
      if status in [:resolved, :closed] do
        DateTime.add(now, -(index * 3600), :second)
      else
        nil
      end
  })
end)

IO.puts("""
Seed complete.

Organizations: 3
Users: 18
Tickets: 80

Ticket statuses:
  Resolved: 60
  Closed:    8
  Open:      6
  Pending:   3
  On hold:   3

Priorities:
  Low:       16
  Normal:    53
  High:      10
  Urgent:    1
""")
