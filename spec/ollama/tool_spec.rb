describe Ollama::Tool do
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
      type: 'function',
      function: {
        name: 'get_current_weather',
        description: "Get the current weather for a location",
        parameters: {
          type: "object",
          properties: {
            location: {
              type: "string",
              description: "The location to get the weather for, e.g. Berlin, Berlin"
            },
            format: {
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
      %{{"type":"function","function":{"name":"get_current_weather","description":"Get the current weather for a location","parameters":{"type":"object","properties":{"location":{"type":"string","description":"The location to get the weather for, e.g. Berlin, Berlin"},"format":{"type":"string","description":"The format to return the weather in, e.g. 'celsius' or 'fahrenheit'","enum":["celsius","fahrenheit"]}},"required":["location","format"]}}}}
    )
  end

  context 'with nested properties' do
    let :address do
      Ollama::Tool::Function::Parameters::Property.new(
        type: 'string',
        description: 'Street address',
      )
    end

    let :city do
      Ollama::Tool::Function::Parameters::Property.new(
        type: 'string',
        description: 'City name',
      )
    end

    let :location_details do
      Ollama::Tool::Function::Parameters::Property.new(
        type: 'object',
        description: 'Location details',
        properties: { address: address, city: city },
      )
    end

    let :nested_parameters do
      Ollama::Tool::Function::Parameters.new(
        type: 'object',
        properties: { location: location_details },
        required: %w[ location ],
      )
    end

    let :nested_tool do
      described_class.new(
        type: 'function',
        function: Ollama::Tool::Function.new(
          name: 'get_location',
          description: 'Get location info',
          parameters: nested_parameters,
        ),
      )
    end

    it 'can serialize nested properties' do
      expect(nested_tool.as_json[:function][:parameters][:properties][:location]).to eq({
        type: 'object',
        description: 'Location details',
        properties: {
          address: { type: 'string', description: 'Street address' },
          city: { type: 'string', description: 'City name' }
        }
      })
    end

    it 'can serialize deeply nested properties' do
      lat = Ollama::Tool::Function::Parameters::Property.new(type: 'number', description: 'Latitude')
      lng = Ollama::Tool::Function::Parameters::Property.new(type: 'number', description: 'Longitude')
      coords = Ollama::Tool::Function::Parameters::Property.new(
        type: 'object',
        description: 'GPS coordinates',
        properties: { lat: lat, lng: lng }
      )
      loc = Ollama::Tool::Function::Parameters::Property.new(
        type: 'object',
        description: 'Location',
        properties: { coordinates: coords }
      )
      event = Ollama::Tool::Function::Parameters::Property.new(
        type: 'object',
        description: 'Event',
        properties: { location: loc }
      )

      deep_tool = described_class.new(
        type: 'function',
        function: Ollama::Tool::Function.new(
          name: 'get_event',
          description: 'Get event info',
          parameters: Ollama::Tool::Function::Parameters.new(
            type: 'object',
            properties: { details: event },
            required: %w[ details ]
          )
        )
      )

      expect(deep_tool.as_json[:function][:parameters][:properties][:details][:properties][:location][:properties][:coordinates][:properties][:lat][:type]).to eq('number')
    end
  end
end
