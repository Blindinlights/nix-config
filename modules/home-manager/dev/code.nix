{ ... }:
{
  programs.codex = {
    enable = true;
    settings = {
      model = "openai/gpt-5-codex";
      model_provider = "openrouter";
      model_providers = {
        openrouter = {
          api_key = "your_openrouter_api_key";
          api_url = "https://openrouter.ai/api/v1";
        };
      };

    };
  };
}
