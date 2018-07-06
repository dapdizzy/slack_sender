defmodule SubscriptionManager do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_subscriber(topic, subscriber) do
    Agent.update(__MODULE__, fn subscribers ->
      subscribers |> Map.update(topic, MapSet.new |> MapSet.put(subscriber), &(&1 |> MapSet.put(subscriber)))
    end)
  end

  def get_subscribers(topic) do
    Agent.get(__MODULE__, fn subscribers -> subscribers[topic] end)
  end
end
