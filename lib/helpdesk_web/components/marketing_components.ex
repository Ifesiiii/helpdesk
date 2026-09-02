defmodule HelpdeskWeb.MarketingComponents do
  @moduledoc """
  Components for the public-facing marketing pages.

  These are deliberately separate from `CoreComponents`, which holds the
  application UI. Marketing styling changes on a different schedule and
  shouldn't drag the app's design system with it.
  """

  use HelpdeskWeb, :html

  @doc """
  A pricing plan card.

  ## Examples

      <.pricing_card name="Team" price={49} highlighted>
        <:feature>SLAs</:feature>
        <:feature>API access</:feature>
        <:cta>Start free trial</:cta>
      </.pricing_card>
  """

  attr :name, :string, required: true
  attr :price, :integer, required: true, doc: "monthly price in USD; 0 renders as Free"
  attr :seats, :any, default: nil, doc: "an integer, or :unlimited"
  attr :highlighted, :boolean, default: false
  attr :rest, :global

  slot :feature, doc: "one per bullet point"
  slot :cta, doc: "call-to-action button content"

  def pricing_card(assigns) do
    ~H"""
    <div
      class={[
        "card bg-base-100 border transition",
        @highlighted && "border-primary shadow-lg scale-[1.02]",
        !@highlighted && "border-base-300"
      ]}
      {@rest}
    >
      <div class="card-body">
        <h3 class="card-title text-lg">
          {@name}
          <span :if={@highlighted} class="badge badge-primary badge-sm">
            Popular
          </span>
        </h3>

        <p class="mt-2">
          <span class="text-3xl font-semibold">
            {if @price == 0, do: "Free", else: "$#{@price}"}
          </span>

          <span
            :if={@price > 0}
            class="text-base-content/60 text-sm"
          >
            /month
          </span>
        </p>

        <p
          :if={@seats}
          class="text-sm text-base-content/70"
        >
          {seat_label(@seats)}
        </p>

        <ul class="mt-4 space-y-1.5 text-sm">
          <li
            :for={feature <- @feature}
            class="flex gap-2"
          >
            <.icon
              name="hero-check"
              class="size-4 text-success shrink-0 mt-0.5"
            />

            {render_slot(feature)}
          </li>
        </ul>

        <div
          :if={@cta != []}
          class="card-actions mt-6"
        >
          <button class={[
            "btn w-full",
            @highlighted && "btn-primary"
          ]}>
            {render_slot(@cta)}
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp seat_label(:unlimited), do: "Unlimited seats"

  defp seat_label(n) when is_integer(n),
    do: "Up to #{n} seats"

  @doc """
  A single headline statistic.
  """

  attr :value, :string, required: true
  attr :label, :string, required: true
  attr :rest, :global

  def stat(assigns) do
    ~H"""
    <div
      class="text-center"
      {@rest}
    >
      <div class="text-3xl font-semibold tabular-nums">
        {@value}
      </div>

      <div class="text-sm text-base-content/60 mt-1">
        {@label}
      </div>
    </div>
    """
  end

  @doc """
  Renders a responsive row of statistics.

  The `divider` option adds vertical dividers between
  statistics on larger screens.

  ## Examples

      <.stat_row
        stats={[
          {"24", "Team members"},
          {"2019", "Founded"},
          {"99%", "Customer satisfaction"}
        ]}
        divider
      />
  """

  attr :stats, :list, required: true
  attr :divider, :boolean, default: false
  attr :rest, :global

  def stat_row(assigns) do
    ~H"""
    <div
      class="grid grid-cols-1 gap-6 sm:grid-flow-col sm:auto-cols-fr"
      {@rest}
    >
      <div
        :for={{{value, label}, index} <- Enum.with_index(@stats)}
        class={[
          @divider &&
            index > 0 &&
            "sm:border-l sm:border-base-300 sm:pl-6"
        ]}
      >
        <.stat
          value={to_string(value)}
          label={label}
        />
      </div>
    </div>
    """
  end

  @doc """
Renders a timeline of entries.

The caller controls how each entry is displayed through
the `:entry` scoped slot.
"""

attr :entries, :list, required: true
attr :rest, :global

slot :entry, required: true

def timeline(assigns) do
  ~H"""
  <div class="space-y-0" {@rest}>
    <div
      :for={entry <- @entries}
      class="relative flex gap-4 pb-8 last:pb-0"
    >
      <div class="flex flex-col items-center">
        <div class="size-3 rounded-full bg-primary"></div>

        <div class="w-px flex-1 bg-base-300 last:hidden"></div>
      </div>

      <div class="flex-1 pb-2">
        {render_slot(@entry, entry)}
      </div>
    </div>
  </div>
  """
end
end
