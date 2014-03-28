class V1Controller < ApplicationController
  def rule
    render json: {rule:[{rule_number:"1.2.2", contents:"Rule text"}]}, status: :ok
  end

  def range
    render json: {}, status: :ok
  end

  def glossary
    render json: {}, status: :ok
  end

  def search
    render json: {}, status: :ok
  end
end
