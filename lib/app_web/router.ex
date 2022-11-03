defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through :browser

    live "/", ThermostatLive
  end
end

defmodule AppWeb.ThermostatLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  # use Phoenix.LiveView
  use AppWeb, :live_view

  def render(assigns) do
    # Basic
    # ~H"""
    # Hello, world!
    # """

    # Dynamic
    # ~H"""
    # <button phx-click="increment">+</button>
    # <a href={@link}>Hello, world!</a>
    # """

    # If statement
    # ~H"""
    # <button phx-click="increment">+</button>
    # Welcome
    # <%= if @logged_in do %>
    #   <%= @logged_in %>
    # <% end %>
    # .
    # """

    # ~H"""
    # <button phx-click="increment">+</button>
    # Welcome
    # <%= if @name do %>
    #   <%= @name %>
    # <% else %>
    #   stranger
    # <% end %>
    # """

    # Nested if statement
    # ~H"""
    # <button phx-click="increment">+</button>
    # <%= if @count >= 1 do %>
    #   <p>Count is high!</p>
    #   <%= if @count >= 2 do %>
    #     <p>Count is very high!</p>
    #   <% end %>
    # <% end %>
    # """

    # For loop
    # ~H"""
    # <button phx-click="increment">+</button>
    # <button phx-click="decrement">-</button>
    # <ul>
    # <%= for num <- @numbers do %>
    #   <li><%= num %></li>
    # <% end %>
    # </ul>
    # """

    # ~H"""
    # <%= for name <- @names do %>
    #   <span>Welcome, <%= name %>.</span>
    #   <%= if name == "Jim" || name == "Joe" do %>
    #     <span>You are a VIP, <%= name %></span>
    #       <%= if name == "Jim" || name == "Joe" do %>
    #         <span><%= name %> ends with m or e</span>
    #       <% end %>
    #   <% end %>
    # <% end %>
    # """

    # ~H"""
    #   <button phx-click="increment">+</button>Hello <%= @name %>
    # """
    # ~H"""
    # <button phx-click="increment">+</button>
    # <%= if @count >= 1 do %>
    #   <p>Count is high!</p>
    #   <%= if @count >= 2 do %>
    #   <p>Count is very high!</p>
    #   <% end %>
    # <% end %>
    # """
    # ~H"""
    # <button phx-click="increment">+</button>Welcome <%= if @user do %><%= @user %><% else %>stranger<% end %>
    # """

    ~H"""
    <ul>
      <%= for todo <- @todos do %>
        <li id={todo["title"]}>
          <form>
            <span><%= todo["title"] %></span>
            <input name="id" />
          </form>
        </li>
      <% end %>
    </ul>
    """
  end

  def mount(_params, assigns, socket) do
    socket = assign(socket, :link, "hey")
    socket = assign(socket, :foo, true)
    socket = assign(socket, :count, 0)
    socket = assign(socket, :name, "Bob")
    socket = assign(socket, :user, nil)
    socket = assign(socket, :names, ["John", "Joe"])
    socket = assign(socket, :logged_in, true)
    socket = assign(socket, :numbers, [])

    socket =
      assign(socket, :todos, [
        %{
          "title" => "Hello"
        },
        %{
          "title" => "World"
        }
      ])

    {:ok, socket}
  end

  def handle_event("increment", _value, socket) do
    socket = assign(socket, :link, "there")
    socket = assign(socket, :count, socket.assigns.count + 1)
    socket = assign(socket, :name, nil)
    socket = assign(socket, :user, "Bob")

    last = List.last(socket.assigns.numbers) || -1
    IO.puts(last)
    socket = assign(socket, :numbers, socket.assigns.numbers ++ [last + 1])

    socket = assign(socket, :logged_in, false)
    {:noreply, socket}
  end

  def handle_event("decrement", _value, socket) do
    socket = assign(socket, :numbers, socket.assigns.numbers |> tl())

    {:noreply, socket}
  end
end
