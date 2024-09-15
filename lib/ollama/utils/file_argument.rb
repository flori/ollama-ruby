module Ollama::Utils::FileArgument
  module_function

  def get_file_argument(path_or_content, default: nil)
    if path_or_content.present? && path_or_content.size < 2 ** 15 &&
        File.basename(path_or_content).size < 2 ** 8 &&
        File.exist?(path_or_content)
      then
      File.read(path_or_content)
    elsif path_or_content.present?
      path_or_content
    else
      default
    end
  end
end
