require 'spec_helper'

describe Ollama::Image do
  let :image do
    described_class.for_filename(asset('kitten.jpg'))
  end

  it 'can be instantiated' do
    expect(image).to be_a described_class
  end

  it 'can be equal or not' do
    expect(image).not_to eq described_class.for_string('')
    expect(image).to eq described_class.for_filename(asset('kitten.jpg'))
  end

  it 'cannot be created via .new' do
    expect {
      described_class.new('nix')
    }.to raise_error NoMethodError
  end

  it 'can be converted to base64 string' do
    expect(image.to_s.size).to eq 132196
    expect(image.to_s.sum).to eq 20420
    expect(image.to_s[0, 40]).to eq '/9j/4AAQSkZJRgABAQAASABIAAD/4QBYRXhpZgAA'
  end

  it 'tracks path of file' do
    expect(image.path).to eq asset('kitten.jpg')
  end

  it 'can be converted into JSON as a quoted base64 string' do
    expect(image.to_json).to eq '"%s"' % image.to_s
  end
end
