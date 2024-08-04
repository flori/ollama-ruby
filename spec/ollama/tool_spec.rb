require 'spec_helper'

RSpec.describe Ollama::Tool do
  let :location do
    Ollama::Tool::Function::Parameters::Property.new(
      type: 'string',
      description: 'The location to get the weather for, e.g. Berlin, Berlin',
    )
  end

  let :format do
    Ollama::Tool::Function::Parameters::Property.new(
      type: 'string',
      description: "The format to return the weather in, e.g. 'celsius' or 'fahrenheit'",
      enum: %w[ celsius fahrenheit ]
    )
  end

  let :parameters do
    Ollama::Tool::Function::Parameters.new(
      type: 'object',
      properties: { location:, format: },
      required: %w[ location format ],
    )
  end

  let :function do
    Ollama::Tool::Function.new(
      name: 'get_current_weather',
      description: 'Get the current weather for a location',
      parameters:,
    )
  end

  let :tool do
    described_class.new(
      type: 'function',
      function:,
    )
  end

  it 'can be instantiated' do
    expect(tool).to be_a described_class
  end

  it 'cannot be converted to JSON' do
    expect(tool.as_json).to eq(
      json_class: described_class.name,
      type: 'function',
      function: {
        json_class: "Ollama::Tool::Function",
        name: 'get_current_weather',
        description: "Get the current weather for a location",
        parameters: {
          json_class: "Ollama::Tool::Function::Parameters",
          type: "object",
          properties: {
            location: {
              json_class: "Ollama::Tool::Function::Parameters::Property",
              type: "string",
              description: "The location to get the weather for, e.g. Berlin, Berlin"
            },
            format: {
              json_class: "Ollama::Tool::Function::Parameters::Property",
              type: "string",
              description: "The format to return the weather in, e.g. 'celsius' or 'fahrenheit'",
              enum: ["celsius", "fahrenheit"]
            }
          },
          required: ["location", "format"]
        },
      }
    )
    expect(tool.to_json).to eq(
      %{{"json_class":"Ollama::Tool","type":"function","function":{"json_class":"Ollama::Tool::Function","name":"get_current_weather","description":"Get the current weather for a location","parameters":{"json_class":"Ollama::Tool::Function::Parameters","type":"object","properties":{"location":{"json_class":"Ollama::Tool::Function::Parameters::Property","type":"string","description":"The location to get the weather for, e.g. Berlin, Berlin"},"format":{"json_class":"Ollama::Tool::Function::Parameters::Property","type":"string","description":"The format to return the weather in, e.g. 'celsius' or 'fahrenheit'","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}}
    )
  end
end
