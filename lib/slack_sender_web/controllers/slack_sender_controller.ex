defmodule SlackSenderWeb.SlackSenderController do
  use SlackSenderWeb, :controller

  def send(conn, params) do
    message = params["message"]
    working_queue = Application.get_env(:rabbitmq_sender, :working_queue)
    IO.puts "Sending message [#{message}] to working queue [#{working_queue}]"
    RabbitMQSender |> RabbitMQSender.send_message(working_queue, message, true)
    IO.puts "Message [#{message}] has been sent to queue [#{working_queue}]"
    json conn, %{sent: true}
  end
end
