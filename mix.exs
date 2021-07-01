defmodule ExFacturapi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_facturapi,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [
          :ex_unit,
          :mix
        ]
      ],
      dialyzer_warnings: [
        :error_handling,
        :race_conditions,
        :unknown
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      name: "ex_facturapi",
      maintainers: ["VentUp"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/Ventup-IT/ex_facturapi"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.7"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:dialyzex, "~> 1.2.0", only: [:dev], runtime: false},
      {:sobelow, "~> 0.8", only: :dev}
    ]
  end
end
