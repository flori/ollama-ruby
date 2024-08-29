module Ollama::Utils::Math
  # Returns the cosine similarity between two vectors +a+ and +b+, 1.0 is
  # exactly the same, 0.0 means decorrelated.
  #
  # @param [Vector] a The first vector
  # @param [Vector] b The second vector
  # @option a_norm [Float] a The Euclidean norm of vector a (default: calculated from a)
  # @option b_norm [Float] b The Euclidean norm of vector b (default: calculated from b)
  #
  # @return [Float] The cosine similarity between the two vectors
  #
  # @example Calculate the cosine similarity between two vectors
  #   cosine_similarity(a: [1, 2], b: [3, 4])
  #
  # @see #convert_to_vector
  # @see #norm
  def cosine_similarity(a:, b:, a_norm: norm(a), b_norm: norm(b))
    a, b = convert_to_vector(a), convert_to_vector(b)
    a.dot(b) / (a_norm * b_norm)
  end

  # Returns the Euclidean norm (magnitude) of a vector.
  #
  # @param vector [Array] The input vector.
  #
  # @return [Float] The magnitude of the vector.
  #
  # @example
  #   norm([3, 4]) # => 5.0
  def norm(vector)
    s = 0.0
    vector.each { s += _1.abs2 }
    Math.sqrt(s)
  end

  # Converts an array to a Numo NArray.
  #
  # @param [Array] vector The input array to be converted.
  #
  # @return [Numo::NArray] The converted NArray, or the original if it's already a Numo NArray.
  #
  # @example Convert an array to a Numo NArray
  #   convert_to_vector([1, 2, 3]) # => Numo::NArray[1, 2, 3]
  def convert_to_vector(vector)
    vector.is_a?(Numo::NArray) and return vector
    Numo::NArray[*vector]
  end
end
