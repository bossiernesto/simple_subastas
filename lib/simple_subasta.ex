defmodule SimpleSubasta do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    failover_node = System.get_env("failover")

    if failover_node do
      Logger.info "Iniciando servidor secundario (Failover)"
      Logger.info "Conectando a #{failover_node}"
      Logger.info Node.connect(:"#{failover_node}")
      start_backup_http_server(failover_node)
    else
      Logger.info "Iniciando simple subasta httpServer"
      start_http_server()
    end
  end

  def start_backup_http_server(node_name) do
    receive do
    after 1000 ->
      Logger.info "Ping to main server..."
      if(Node.ping(:"#{node_name}") == :pong) do
        Logger.info "El server principal no esta respondiendo"
        start_http_server()
      else
        start_backup_http_server(node_name)
      end
    end
  end

  def start_http_server do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(SimpleSubasta.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SimpleSubasta.Endpoint, []),
      # Start your own worker by calling: SimpleSubasta.Worker.start_link(arg1, arg2, arg3)
      # worker(SimpleSubasta.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleSubasta.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SimpleSubasta.Endpoint.config_change(changed, removed)
    :ok
  end
end
