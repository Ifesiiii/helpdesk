defmodule HelpdeskWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use HelpdeskWeb, :html

  import HelpdeskWeb.CoreComponents
  import HelpdeskWeb.MarketingComponents

  embed_templates "page_html/*"
end
