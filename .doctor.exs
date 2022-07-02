%Doctor.Config{
  ignore_modules: [
    LearnElixirGraphql.Support.TestSetup,
    LearnElixirGraphql.DataCase,
    LearnElixirGraphqlWeb.ErrorView,
    LearnElixirGraphqlWeb.Router,
    LearnElixirGraphqlWeb.Endpoint,
    LearnElixirGraphqlWeb.Schema,
    LearnElixirGraphqlWeb.UserSocket,
    LearnElixirGraphqlWeb,
    LearnElixirGraphql.Pipeline.Supervisor,
    LearnElixirGraphql.Pipeline.Producer,
    LearnElixirGraphql.Pipeline.Consumer
  ],
  ignore_paths: [],
  min_module_doc_coverage: 0,
  min_module_spec_coverage: 100,
  min_overall_doc_coverage: 0,
  min_overall_spec_coverage: 100,
  moduledoc_required: true,
  exception_moduledoc_required: true,
  raise: false,
  reporter: Doctor.Reporters.Full,
  struct_type_spec_required: true,
  umbrella: false
}
