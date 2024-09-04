module Ollama::Utils::FileArgument
  module_function

  def get_file_argument(prompt, default: nil)
    if prompt.present? && prompt.size < 2 ** 15 &&
        File.basename(prompt).size < 2 ** 8 &&
        File.exist?(prompt)
      then
      File.read(prompt)
    elsif prompt.present?
      prompt
    else
      default
    end
  end
end
