defmodule Mix.Tasks.Gen.Callback do
  use Mix.Task

  @moduledoc """
  Generate a callback module for a given behaviour.

      mix gen.callback BEHAVIOUR

  """

  @impl true
  def run(args) do
    Mix.Task.run("loadpaths")

    case args do
      [behaviour] ->
        gen_callback(behaviour)

      _ ->
        Mix.raise("""
        Invalid arguments, expected one of:

            mix hex.publish BEHAVIOUR

        """)
    end
  end

  ## Below copied and modified from IEx.Introspection code.

  defp gen_callback(behaviour) do
    module = Module.concat([behaviour])

    case Code.Typespec.fetch_callbacks(module) do
      {:ok, callbacks} ->
        optional_callbacks = module.behaviour_info(:optional_callbacks) |> Enum.into(MapSet.new())

        defs =
          callbacks
          |> Enum.map(&translate_callback/1)
          |> Enum.sort()
          |> Enum.map(&format_callback(&1, optional_callbacks, module))

        """
        defmodule My#{behaviour} do
          @behaviour #{behaviour}

          #{defs}
        end
        """
        |> Code.format_string!()
        |> IO.puts()

      :error ->
        Mix.raise("No callbacks found for #{behaviour}")
    end
  end

  defp translate_callback({name_arity, specs}) do
    case translate_callback_name_arity(name_arity) do
      {:macrocallback, _, _} = kind_name_arity ->
        # The typespec of a macrocallback differs from the one expressed
        # via @macrocallback:
        #
        #   * The function name is prefixed with "MACRO-"
        #   * The arguments contain an additional first argument: the caller
        #   * The arity is increased by 1
        #
        specs =
          Enum.map(specs, fn {:type, line1, :fun, [{:type, line2, :product, [_ | args]}, spec]} ->
            {:type, line1, :fun, [{:type, line2, :product, args}, spec]}
          end)

        {kind_name_arity, specs}

      kind_name_arity ->
        {kind_name_arity, specs}
    end
  end

  defp translate_callback_name_arity({name, arity}) do
    case Atom.to_string(name) do
      "MACRO-" <> macro_name -> {:macrocallback, String.to_atom(macro_name), arity - 1}
      _ -> {:callback, name, arity}
    end
  end

  defp format_callback({{kind, name, _arity}, specs}, optional_callbacks, module) do
    Enum.map(specs, fn spec ->
      Code.Typespec.spec_to_quoted(name, spec)
      |> Macro.prewalk(&drop_macro_env/1)
      |> format_typespec(kind, 0, optional_callbacks, module)
    end)
  end

  defp drop_macro_env({name, meta, [{:::, _, [_, {{:., _, [Macro.Env, :t]}, _, _}]} | args]}),
    do: {name, meta, args}

  defp drop_macro_env(other), do: other

  defp format_typespec(definition, kind, _nesting, optional_callbacks, module) do
    kind =
      case kind do
        :callback -> "def"
        :macrocallback -> "defmacro"
      end

    {head, body, optional?} = parse_definition(definition, optional_callbacks, module)

    """
    #{if optional?, do: "\# Optional"}
    @impl true
    #{kind} #{head} do
      #{body}
    end
    """
  end

  defp parse_definition({:when, _, [left, _]}, optional_callbacks, module) do
    parse_definition(left, optional_callbacks, module)
  end

  defp parse_definition({:::, _, [{name, _, args}, _returns]}, optional_callbacks, module) do
    args_string = Enum.map_join(args, ", ", &arg_string(&1, module))
    head = "#{name}(#{args_string})"
    body = ~s{raise "not implemented yet"}
    optional? = {name, length(args)} in optional_callbacks
    {head, body, optional?}
  end

  defp arg_string({:t, _, args}, module) when args in [nil, []] do
    name = module |> Module.split() |> Enum.reverse() |> hd() |> Macro.underscore()
    "_#{name}"
  end

  defp arg_string({arg_name, _, args}, _module) when is_atom(arg_name) and args in [nil, []] do
    "_#{arg_name}"
  end

  defp arg_string({:::, _, [{arg_name, _, nil}, _]}, _module) when is_atom(arg_name) do
    "_#{arg_name}"
  end

  defp arg_string({{:., _, [module, :t]}, _, []}, _module) when is_atom(module) do
    "_#{Macro.underscore(module)}"
  end
end
